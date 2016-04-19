---
layout: post
title: Streamline python Popen output
tags: [python, popen]
---

Problem: when execute a command from a Python script, I want to _grep_
a pattern in its output, as well as seeing the normal runtime output on
terminal and getting the exit code.

The [check_output](https://docs.python.org/2/library/subprocess.html#subprocess.check_output)
method from [os.subprocess](https://docs.python.org/2/library/subprocess.html)
module is great, I can write

```python
try:
    output = subprocess.check_output(['ping', '-c', '4', 'localhost'])
    sys.stdout.write(output)
except subprocess.CalledProcessError as e:
    ...

# Now search the output
```

Unfortunately I can only see the output after it terminated (think about my
Jenkins job invoked a command from Python script and it runs for 10 minutes),
and the method is new in version **2.7**, but CentOS 6 with Python 2.6 is still
widely used in our prod system.

The other method [check_call](https://docs.python.org/2/library/subprocess.html#subprocess.check_call)
does not give me the output at all, `os.system` has the same issue.

So here's my solution: use
[subprocess.Popen](https://docs.python.org/2/library/subprocess.html#popen-constructor)
with I/O redirection, and use
[select](https://docs.python.org/2/library/select.html) for non-blocking read.

```python
# foo.py

import sys
from subprocess import PIPE, Popen
from select import select

p = Popen('ping -c 4 localhost', shell=True, stdout=PIPE, bufsize=1)

while True:
    if select([p.stdout.fileno()], [], [], 0)[0]:
        line = p.stdout.readline()
        if not line:
            break
        sys.stdout.write(line)

sys.exit(p.wait())
```

![Streamline popen output](/images/2016/streamline-popen-output.gif)
