from flask import Flask
from geoip import open_database

def create_app():
    app = Flask(__name__)
    geoip = open_database('./GeoLite2-Country.mmdb')

    @app.route("/")
    def hello():
        return "Hello, World!"

    @app.route("/ip")
    def ip():
        match = geoip.lookup('17.0.0.1')
        if match:
            return match.country

        return "Not Available"


    return app

app = create_app()
