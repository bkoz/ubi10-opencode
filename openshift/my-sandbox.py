from k8s_agent_sandbox import SandboxClient

client = SandboxClient()

sandbox = client.create_sandbox(
    warmpool="python-sandbox-pool",
    namespace="bk-sandboxes",
)
try:
    result = sandbox.commands.run("echo 'Hello from Agent Sandbox!'")
    print(result.stdout)
    # Hello from Agent Sandbox!
finally:
    sandbox.terminate()
