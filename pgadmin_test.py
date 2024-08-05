import requests

# Define the pgAdmin login URL and credentials
pgadmin_url = "http://localhost:8100"
login_url = f"{pgadmin_url}/login"
credentials = {
    "email": "pgadmin@fake.com",
    "password": "street"
}

# Start a session to persist cookies
session = requests.Session()

# Attempt to login
response = session.post(login_url, data=credentials)

# Check the response
if response.ok:
    print("Login successful!")
else:
    print("Login failed. Please check your credentials and try again.")
    print("Status Code:", response.status_code)
    print("Response Text:", response.text)
