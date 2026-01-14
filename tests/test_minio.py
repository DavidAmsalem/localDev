import boto3
from botocore.client import Config

def test_minio():
    try:
        print('Connecting to MinIO (S3)...')
        s3 = boto3.resource('s3',
                    endpoint_url='http://localhost:9000',
                    aws_access_key_id='minioadmin',
                    aws_secret_access_key='minioadmin',
                    config=Config(signature_version='s3v4'),
                    region_name='us-east-1'
        )

        print('\nListing buckets:')
        for bucket in s3.buckets.all():
            print(f' - {bucket.name}')
            
            print(f'   Objects in {bucket.name}:')
            bucket_obj = s3.Bucket(bucket.name)
            for obj in bucket_obj.objects.all():
                print(f'    - {obj.key} ({obj.size} bytes)')

        print('\nMinIO Test Passed!')

    except Exception as e:
        print(f'Error connecting to MinIO: {e}')

if __name__ == '__main__':
    test_minio()

