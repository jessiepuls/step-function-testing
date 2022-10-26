package main

import (
	"context"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context) {
	log.Println("Hello World!")
}

func main() {
	lambda.Start(HandleRequest)
}
