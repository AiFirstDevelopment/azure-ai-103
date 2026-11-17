"""Episode 1: the first model call in Microsoft Foundry, with no key.

DefaultAzureCredential finds your `az login` and gets a token for the project; the Foundry User role that
infra/up.sh assigned is what lets that token call the model. Nothing here reads a key: take the role away and the
call is refused, whatever key variables are set.

    python ep01_foundry_setup/first_call.py
"""
import os
import sys
import time
from pathlib import Path

from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

ROOT = Path(__file__).resolve().parent.parent
QUESTION = "In two sentences, what is a token, to a language model?"


def settings():
    """FOUNDRY_PROJECT_ENDPOINT and FOUNDRY_MODEL_DEPLOYMENT, from the environment or the .env up.sh wrote."""
    values = {}
    env = ROOT / ".env"
    if env.exists():
        for line in env.read_text().splitlines():
            if "=" in line and not line.startswith("#"):
                k, v = line.split("=", 1)
                values[k.strip()] = v.strip()
    values.update({k: v for k, v in os.environ.items() if k.startswith("FOUNDRY_")})
    return values["FOUNDRY_PROJECT_ENDPOINT"], values["FOUNDRY_MODEL_DEPLOYMENT"]


def main():
    endpoint, deployment = settings()
    project = AIProjectClient(endpoint=endpoint, credential=DefaultAzureCredential())
    openai = project.get_openai_client()

    print(f"project:    {endpoint.rsplit('/', 1)[-1]}")
    print(f"deployment: {deployment}")
    print(f"question:   {QUESTION}\n")
    start = time.monotonic()
    response = openai.responses.create(model=deployment, input=QUESTION)
    seconds = time.monotonic() - start

    print(response.output_text.strip())
    u = response.usage
    print(f"\ninput tokens:  {u.input_tokens}")
    print(f"output tokens: {u.output_tokens}"
          + (f" (of which reasoning: {u.output_tokens_details.reasoning_tokens})"
             if getattr(u, "output_tokens_details", None) and u.output_tokens_details.reasoning_tokens else ""))
    print(f"total tokens:  {u.total_tokens}")
    print(f"model:         {response.model}")
    print(f"seconds:       {seconds:.1f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
