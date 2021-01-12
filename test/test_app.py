import pytest
from src.app import add, multiply, substract, divide


def test_add():
    assert add(1, 2) == 3
    assert add(-1, 10) == 9


def test_substract():
    assert substract(10, 2) == 8
    assert substract(2, 19) == 17


def test_divide():
    assert divide(18, 6) == 3


def test_multiply():
    assert multiply(0, 10) == 0
    assert multiply(5.1, 2) == 10.2
