# Python

## Monkey-patch instance methods

```python
def foo(self):
  # ...

instance.foo = types.MethodType(foo, instance, instance.__class__)
```
