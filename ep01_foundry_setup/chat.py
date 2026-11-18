"""Episode 1: talk to the model you deployed, and watch each answer arrive as it is written.

The same connection as first_call.py (the project endpoint and deployment from .env, your `az login` as the
credential), in a loop: type a question, read the answer, ask the next. An empty line or Ctrl+C quits.

The answer is streamed. With stream=True the Responses API sends events as the model writes; each
"response.output_text.delta" event carries the next piece of text. Printing each piece at once, with flush=True so the
terminal shows it immediately, gives the typewriter effect. A reasoning model such as gpt-5-mini thinks first, so the
first words can take a few seconds to arrive: until they do, a "Thinking..." spinner shows the wait, and is erased
before the answer is printed.

    python ep01_foundry_setup/chat.py
"""
import itertools
import sys
import threading
import time

from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

from first_call import settings


def spin(stop):
    """Show "Thinking..." with a turning bar until stop is set, then erase it."""
    for frame in itertools.cycle("|/-\\"):
        if stop.is_set():
            break
        print(f"\r{frame} Thinking...", end="", flush=True)
        time.sleep(0.1)
    print("\r" + " " * 16 + "\r", end="", flush=True)   # clear the spinner's line


def answer(openai, deployment, question):
    """Stream one answer to the terminal as it is written; return its text."""
    stop = threading.Event()
    spinner = threading.Thread(target=spin, args=(stop,))
    spinner.start()
    text = []
    try:
        stream = openai.responses.create(model=deployment, input=question, stream=True)
        for event in stream:
            if event.type == "response.output_text.delta":
                if not stop.is_set():       # the first words: stop the spinner before printing
                    stop.set()
                    spinner.join()
                print(event.delta, end="", flush=True)   # each piece shown the moment it arrives
                text.append(event.delta)
            elif event.type == "error":
                raise RuntimeError(event.message)
    finally:
        stop.set()
        spinner.join()
    print("\n")                                       # end the answer's line, then a blank line before the next prompt
    return "".join(text)


def main():
    endpoint, deployment = settings()
    project = AIProjectClient(endpoint=endpoint, credential=DefaultAzureCredential())
    openai = project.get_openai_client()
    print(f"Connected to {deployment} in your Azure subscription. Ask anything.\n")
    while True:
        try:
            question = input("> ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            return 0
        if not question:
            return 0
        answer(openai, deployment, question)


if __name__ == "__main__":
    sys.exit(main())
