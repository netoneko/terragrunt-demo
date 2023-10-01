from flask import Flask, request
from geoip import open_database

def create_app():
    app = Flask(__name__)
    geoip = open_database("./GeoLite2-Country.mmdb")

    @app.route("/")
    def hello():
        return "Hello, World!"

    @app.route("/ip")
    def ip():
        try:
            client_ip = request.headers.get("X-Forwarded-For")
            match = geoip.lookup(client_ip)
            if match:
                return match.country
        except Exception as e:
            app.logger.error("Could not resolve client ip %s, X-Forwarded-For request header might have incorrect value")

        return "Not Available", 500


    return app

app = create_app()
