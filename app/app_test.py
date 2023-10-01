import pytest
from app import create_app

@pytest.fixture()
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
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

def test_request_example(client):
    response = client.get("/")
    assert b"Hello, World!" in response.data
    assert 200 == response.status_code

def test_request_ip_without_header(client):
    response = client.get("/ip")
    assert b"Not Available" == response.data
    assert 500 == response.status_code

def test_request_ip_with_header(client):
    response = client.get("/ip", headers={'X-Forwarded-For': '17.0.0.1'})
    assert b"US" == response.data
    assert 200 == response.status_code
