const { LambdaClient, InvokeCommand } = require("@aws-sdk/client-lambda");

const client = new LambdaClient({});

async function testResponseMessage({ functionName, expectedMessage }) {
  console.log(`Testing function ${functionName}`);

  const input = {
    FunctionName: functionName,
    InvocationType: "RequestResponse",
    Payload: Buffer.from(
      JSON.stringify({
        test: true,
        timestamp: new Date().toISOString(),
      }),
    ),
  };

  const command = new InvokeCommand(input);
  const testResult = await client.send(command);

  // Convert Uint8Array to string and parse JSON
  const payload = JSON.parse(new TextDecoder().decode(testResult.Payload));

  const message = JSON.parse(payload.body).message;

  if (message !== expectedMessage) {
    throw new Error(
      `Expected ${functionName} message to be ${expectedMessage}, got ${message}`,
    );
  }
}

const handler = async (_event, context) => {
  console.log("Running end-to-end tests...");

  try {
    // Test hello-fn
    await testResponseMessage({
      functionName: process.env.HELLO_FUNCTION_NAME,
      expectedMessage: "Hello!",
    });

    // Test goodbye-fn
    await testResponseMessage({
      functionName: process.env.GOODBYE_FUNCTION_NAME,
      expectedMessage: "Goodbye!",
    });

    console.log(`All tests passed ✅`);

    // Return test results
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Tests passed",
        timestamp: new Date().toISOString(),
      }),
    };
  } catch (error) {
    console.error("Tests failed:", error);
    throw error;
  }
};

module.exports = { handler };
