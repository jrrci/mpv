
#!/usr/bin/env python
"""
This script takes a media filename of a movie or TV episode as parameter
and opens the corresponding IMDb page with the webbrowser.

Requires the following pip packages:
guessit
cinemagoer

This file is part of the mpv-open-imdb-page mpv script:
https://github.com/ctlaltdefeat/mpv-open-imdb-page
"""

import sys
import webbrowser

from guessit import guessit
from imdb import Cinemagoer


def get_imdb_url(filename):
    result = None
    ia = Cinemagoer()
    g = guessit(filename)
    title = g["title"]
    if "year" in g:
        title = "{} {}".format(title, g["year"])
    results = ia.search_movie(title)
    if g["type"] == "episode":
        it = iter(res for res in results if res["kind"] == "tv series")
        while not result:
            series = next(it)
            season = g["season"]
            try:
                ia.update_series_seasons(series, [season])
                result = series["episodes"][season][g["episode"]]
            except Exception:
                pass
    else:
        result = next(
            iter(
                res
                for res in results
                if res["kind"] not in ["tv series", "episode"]
            )
        )
    return ia.get_imdbURL(result)


if __name__ == "__main__":
    try:
        url = get_imdb_url(sys.argv[1])
        webbrowser.open_new_tab(url)
    except Exception as e:
        print("ERROR: {}".format(e))
        sys.exit(1)
