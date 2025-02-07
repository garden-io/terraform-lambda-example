const handler = async (event, context) => {
  // Log startup message
  console.log("Lambda function 'Goodbye' started:", {
    functionName: context.functionName,
    functionVersion: context.functionVersion,
    awsRequestId: context.awsRequestId,
    remainingTimeMs: context.getRemainingTimeInMillis(),
  });

  try {
    // Parse the incoming event if it's from API Gateway
    const body = event.body ? JSON.parse(event.body) : {};

    // Basic response
    const response = {
      message: "Goodbye!",
      timestamp: new Date().toISOString(),
      event: event,
    };

    // Return success response
    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(response),
    };
  } catch (error) {
    console.error("Error processing request:", error);

    // Return error response
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: "Internal server error",
        error: error.message,
      }),
    };
  }
};

module.exports = { handler };
