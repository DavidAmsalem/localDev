import boto3
from botocore.client import Config
import os

def test_minio():
    try:
        print("Connecting to MinIO (S3)...")
        s3 = boto3.resource("s3",
                    endpoint_url="http://localhost:9000",
                    aws_access_key_id="minioadmin",
                    aws_secret_access_key="minioadmin",
                    config=Config(signature_version="s3v4"),
                    region_name="us-east-1"
        )

        bucket_name = "test-verification-bucket"
        file_name = "test_file.txt"
        file_content = "This is a test file for MinIO verification."

        # 1. Create Bucket
        if s3.Bucket(bucket_name) not in s3.buckets.all():
            print(f"Creating bucket: {bucket_name}")
            s3.create_bucket(Bucket=bucket_name)
        else:
            print(f"Bucket {bucket_name} already exists.")

        # 2. Upload File
        print(f"Uploading file: {file_name}")
        with open(file_name, "w") as f:
            f.write(file_content)
        
        s3.Bucket(bucket_name).upload_file(file_name, file_name)
        print("Upload successful.")

        # 3. List Objects
        print(f"\nListing objects in {bucket_name}:")
        bucket = s3.Bucket(bucket_name)
        found = False
        for obj in bucket.objects.all():
            print(f" - {obj.key} ({obj.size} bytes)")
            if obj.key == file_name:
                found = True
        
        if not found:
            print("ERROR: Uploaded file not found in listing!")
        
        # 4. Delete File
        print(f"\nRemoving file: {file_name}")
        s3.Object(bucket_name, file_name).delete()
        print("Deletion successful.")

        # Cleanup local file
        if os.path.exists(file_name):
            os.remove(file_name)

        print("\nMinIO Test Passed!")

    except Exception as e:
        print(f"Error executing MinIO tests: {e}")

if __name__ == "__main__":
    test_minio()

