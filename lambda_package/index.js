// Import the AWS SDK for JavaScript v3
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

// Initialize the DynamoDB client
// Make sure to replace 'ap-southeast-1' with your actual AWS region
const ddbClient = new DynamoDBClient({ region: 'ap-southeast-1' });
const ddb = DynamoDBDocumentClient.from(ddbClient);

// The handler function that Lambda will invoke
export const handler = async (event) => {
    // Extract userId from the query string parameters of the API Gateway request
    const userId = event.queryStringParameters.userId;
    const tableName = process.env.TABLE_NAME;

    const params = {
        TableName: tableName,
        Key: { 
            "userId": userId 
        }
    };

    try {
        // Create a new GetCommand with the parameters
        const command = new GetCommand(params);
        // Fetch the item from DynamoDB
        const { Item } = await ddb.send(command);

        if (Item) {
            // If the item is found, return it with a 200 OK status
            return {
                statusCode: 200,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*' // Enable CORS
                },
                body: JSON.stringify(Item)
            };
        } else {
            // If no item is found, return a 404 Not Found status
            return {
                statusCode: 404,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                body: JSON.stringify({ message: "No user data found for ID: " + userId })
            };
        }
    } catch (err) {
        // If there's an error, log it and return a 500 Internal Server Error status
        console.error("Unable to retrieve data:", err);
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify({ message: "Failed to retrieve user data" })
        };
    }
};