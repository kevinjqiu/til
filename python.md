---
title: python
category: Python
layout: 2017/sheet
tags: []
updated: 2017-08-26
weight: -10
intro: |
  Python tips & tricks
---

Python
------

### Monkey-patch instance methods

```python
def foo(self):
  # ...

instance.foo = types.MethodType(foo, instance, instance.__class__)
```
