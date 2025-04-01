import { Construct } from "constructs";
import { S3Bucket } from "@cdktf/provider-aws/lib/s3-bucket";

class MyS3Bucket extends Construct {
  public readonly bucket: S3Bucket;

  constructor(scope: Construct, id: string, bucketName: string) {
    super(scope, id);

    this.bucket = new S3Bucket(this, "MyBucket", {
      bucket: bucketName,
    });
  }
}

-----------

import { App, TerraformStack } from "cdktf";
import { AwsProvider } from "@cdktf/provider-aws";
import { MyS3Bucket } from "./MyS3Bucket"; // Import our construct

class MyStack extends TerraformStack {
  constructor(scope: App, id: string) {
    super(scope, id);

    new AwsProvider(this, "AWS", { region: "us-east-1" });

    // Use the custom construct to create an S3 bucket
    new MyS3Bucket(this, "MyCustomBucket", "my-cdktf-bucket");
  }
}

const app = new App();
new MyStack(app, "MyTerraformStack");
app.synth();
