"""Shared helpers packaged in a Lambda layer (demo)."""


def greet(name: str) -> str:
    return f"Hello, {name} — from custom myutils layer"


def add(a: int, b: int) -> int:
    return a + b
