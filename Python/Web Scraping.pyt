import gazpacho as gaz
import requests

url = 'https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc'

resp = get(url)
resp.status_code

imdb = gaz.Soup(resp.text)

imdb.find("h3",{'class':"lister-item-header"},mode ="first").strip()

titles =imdb.find("h3",{'class':"lister-item-header"})

clean_titles = []
for title in titles:
    clean_titles.append(title.strip())

print(clean_titles)

ratings = imdb.find("div",{"class":"ratings-imdb-rating"})
ratings = [float(rating.strip()) for rating in ratings]
print(ratings)

import pandas as pd

imdb_movies = pd.DataFrame({
    "title": clean_titles,
    "rating": ratings
})

imdb_movies
