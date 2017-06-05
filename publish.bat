rem ###########################################################################
rem Author: Todd G. Hetrick
rem Date:   6/5/2017
rem ###########################################################################

rem Set-up variables
SET REGION="us-east-1"
SET ENTRY_POINT="index.handler"
SET FUNCTION_NAME="svcplatform-write-to-sqs"
SET FUNCTION_FILE="write2sqs.zip"
SET EXEC_ROLE="arn:aws:iam::503080364706:role/Service-Platform-Lambda-Role"
SET DESCR="Lambda function create a message on an AWS SQS Queue."
SET QUEUE_URL="https://sqs.us-east-1.amazonaws.com/503080364706/msgq-svcplatform-sowdocset-builder"

rem Step 1: Remove write2sqs.zip and recreate with 7zip Command Line Utiilty
del %FUNCTION_FILE%
7z a %FUNCTION_FILE% * -r -x!*.zip -x!*.json -x!*.log -x!*.git -x!*.bat

rem Step 2: Upload the Lambda function
aws lambda create-function ^
  --region %REGION% ^
  --function-name %FUNCTION_NAME% ^
  --zip-file fileb://%FUNCTION_FILE% ^
  --role %EXEC_ROLE% ^
  --environment Variables={REGION=%REGION%,QUEUE_URL=%QUEUE_URL%} ^
  --handler %ENTRY_POINT% ^
  --runtime nodejs6.10 ^
  --description %DESCR% ^
  --timeout 60 ^
  --memory-size 128 ^
  --debug
