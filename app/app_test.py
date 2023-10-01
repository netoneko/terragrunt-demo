import pytest
from app import create_app

@pytest.fixture()
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
        "ENV": "testing",
    })

    # other setup can go here

    yield app

    # clean up / reset resources here


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()

def test_request_root(client):
    response = client.get("/", headers={"X-Forwarded-For": "17.0.0.1"})
    assert b"Hello, 17.0.0.1, your location is US. Welcome to testing" in response.data
    assert 200 == response.status_code

def test_request_index_html(client):
    response = client.get("/index.html", headers={"X-Forwarded-For": "17.0.0.1"})
    assert b"Hello, 17.0.0.1, your location is US. Welcome to testing" in response.data
    assert 200 == response.status_code


def test_request_ip_without_header(client):
    response = client.get("/")
    assert b"Hello, stranger, your location is unknown. Welcome to testing" == response.data
    assert 200 == response.status_code
