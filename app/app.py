from flask import Flask, request, render_template_string, render_template
from geoip import open_database
import os

def get_client_ip_from_request(request):
    return request.headers.get("X-Forwarded-For")


def get_country_from_client_ip(geoip, client_ip):
    try:
        match = geoip.lookup(client_ip)
        if match:
            return match.country
    except Exception as e:
        app.logger.error(f"Could not resolve client ip {client_ip}, X-Forwarded-For request header might have incorrect value")


def get_input_from_request(request):
    try:
        return request.get_json()['input']
    except Exception as e:
        app.logger.error('Could not get user input, correct format is a POST request {"input":"value"} with application/json content type')


def create_app():
    app = Flask(__name__)
    app.config.update({
        "ECHO_INPUT": os.environ.get('ECHO_INPUT', "echo")
    })
    geoip = open_database("./GeoLite2-Country.mmdb")


    @app.route("/")
    def root():
        return render_template("index.html", input=app.config.get("ECHO_INPUT"))

    @app.route("/index.html")
    def index():
        return render_template("index.html", input=app.config.get("ECHO_INPUT"))

    @app.route("/ip")
    def ip():
        try:
            client_ip = request.headers.get("X-Forwarded-For")
            match = geoip.lookup(client_ip)
            if match:
                return match.country
        except Exception as e:
            app.logger.error(f"Could not resolve client ip {client_ip}, X-Forwarded-For request header might have incorrect value")

        return "Not Available", 500


    @app.route("/echo", methods=["POST"])
    def echo():
        client_ip = get_client_ip_from_request(request)
        result = {
            'source': client_ip,
            'input': get_input_from_request(request),
            'country': get_country_from_client_ip(geoip, client_ip),
        }

        if not result.get('input'):
            result["error"] = 'Malformed or missing input'
            return result, 500

        return result

    return app


app = create_app()
