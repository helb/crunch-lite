# `crunch-lite`

> Slow but thorough PNG optimizer (just a glorified `pnquant | zopfli` alias inspired by [chrissimpkins’ Crunch](https://github.com/chrissimpkins/Crunch/))


## Dependencies

- zsh or bash
- `mktemp` from [coreutils](https://www.gnu.org/software/coreutils/coreutils.html)
- [pngquant](https://pngquant.org/)
- [zopfli](https://github.com/google/zopfli/)
- [file](https://www.darwinsys.com/file/)
- [awk](https://www.gnu.org/software/gawk/gawk.html)


## Usage

```
$ crunch <image 1> … <image n>
Optimizing 1.png ... 40 -> 36 -> 32 (80.00 %)
Optimizing 2.png ... 284 -> 108 -> 96 (33.80 %)
Optimizing 3.png ... 36 -> 16 -> 16 (44.44 %)
# or just:
$ crunch *png
```

The printed file fizes are:

- the original file
- after `pngquant`
- after `zopflipng`

> ❗ it overwites the files, make sure to have a backup if needed
