from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def index():
    # SAのトークンファイルを読む（通常 /var/run/secrets/kubernetes.io/serviceaccount/token）
    try:
        with open("/var/run/secrets/kubernetes.io/serviceaccount/token", "r") as f:
            sa_token = f.read()
    except Exception as e:
        sa_token = f"Error reading token: {e}"

    # ConfigMapを環境変数やファイルから取得（例として環境変数） 
    config_value = os.getenv("MY_CONFIG_VALUE", "Config not found")

    # ホスト名（Pod名やNode名）も取得してみる
    hostname = os.uname().nodename

    return f"""
    <html>
    <head>
    <style>
        body {{
        background-color: green;
        font-family: Arial, sans-serif;
        padding: 20px;
        }}
        pre {{
        background-color: #f0f0f0;
        padding: 10px;
        border-radius: 5px;
        overflow-x: auto;
        }}
    </style>
    </head>
    <body>
        <h1>Service Account Token:</h1><pre>{sa_token[:100]}...</pre>
        <h1>ConfigMap Value:</h1><p>{config_value}</p>
        <h1>Hostname:</h1><p>{hostname}</p>
    </body>
    </html>
    """
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
