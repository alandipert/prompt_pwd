# prompt_pwd

This is a small C program that prints an abbreviated representation of the
current working directory's path. It was designed to work with Bash's
[PROMPT_COMMAND](https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x264.html) in
order to produce a terse `PS1` prompt that includes the current working
directory path.

## Example

If I'm in the directory `/home/alan/github/alandipert/prompt_pwd`,
my Bash prompt will look like this:

```
alan@ubuntu:~/g/a/prompt_pwd$
```

## Configuration

Configuration similar to the following in your `~/.bashrc` can be used:

```
PROMPT_COMMAND='PWD_ABBREV=$(prompt_pwd)'
PS1='\u@\h:${PWD_ABBREV}\$ '
```

## Build and install

```
make
sudo make install
```

By default, `prompt_pwd` will be installed to `/usr/local/bin/prompt_pwd`.

## Thanks

Thanks to [Dave Yarwood](https://blog.djy.io/) for showing me [Fish shell](https://fishshell.com/), the [default prompt](https://github.com/fish-shell/fish-shell/blob/30940916bdd0dbe06e00059beac2d32c39aa91e3/share/functions/prompt_pwd.fish) of
which inspired `prompt_pwd`.

Thank you also to [Rainer Joswig](https://twitter.com/rainerjoswig) for
assistance with the original [Common
Lisp](https://en.wikipedia.org/wiki/Common_Lisp) prototype.

## Lisp version

`prompt_pwd` was originally prototyped in [SBCL](http://www.sbcl.org/) and later ported to C to improve its efficiency. The original Lisp code is below.

```lisp
#!/usr/bin/sbcl --script

(defun split-string (str delim-char)
  (loop for pos0 = -1 then pos1
        for pos1 = (position delim-char str :start (1+ pos0))
        collect (subseq str (1+ pos0) (or pos1 (length str)))
        while pos1))

(defun abbreviate-butlast (path)
  (loop for (item . rest) on path
        collect (if (and rest (> (length item) 1))
                    (subseq item 0 1)
                    item)))

(defun abbreviate* (home-str cwd-str)
  (let* ((cwd-path (split-string cwd-str #\/))
         (home-path (split-string home-str #\/))
         (home-shortened (if (eql 0 (search home-path cwd-path :test #'equalp))
                             (cons "~" (nthcdr (length home-path) cwd-path))
                             cwd-path)))
    (format nil "~{~A~^/~}" (abbreviate-butlast home-shortened))))

(defun abbreviate (cwd-str)
  (let* ((home-str (sb-ext:posix-getenv "HOME")))
    (cond ((equal cwd-str home-str) "~")
          ((equal cwd-str "/") "/")
          (t (abbreviate* home-str cwd-str)))))

(loop for line = (read-line nil nil nil)
      while line
      do (princ (abbreviate line)))
```

## License

`prompt_pwd` is distributed under the [MIT
License](https://opensource.org/licenses/MIT), a copy of which is included in
the file `LICENSE`.
