from flask import Flask, request, render_template_string, render_template
from geoip import open_database
import os

def get_client_ip_from_request(request):
    return request.headers.get("X-Forwarded-For", "stranger")


def get_country_from_client_ip(geoip, client_ip):
    try:
        match = geoip.lookup(client_ip)
        if match:
            return match.country
    except Exception as e:
        app.logger.error(f"Could not resolve client ip {client_ip}, X-Forwarded-For request header might have incorrect value")
    return "unknown"


def get_input_from_request(request):
    try:
        return request.get_json()['input']
    except Exception as e:
        app.logger.error('Could not get user input, correct format is a POST request {"input":"value"} with application/json content type')


def create_app():
    app = Flask(__name__)
    app.config.update({
        "ENV": os.environ.get('ENV', "echo")
    })
    geoip = open_database("./GeoLite2-Country.mmdb")


    @app.route("/")
    @app.route("/index.html")
    def root():
        client_ip = get_client_ip_from_request(request)
        context = {
            "client_ip": client_ip,
            "country": get_country_from_client_ip(geoip, client_ip),
            "env": app.config.get("ENV"),
        }
        return render_template("index.html", **context)


    return app


app = create_app()
