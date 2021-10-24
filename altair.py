# -*- coding: utf-8 -*-


import altair as alt
import pandas as pd

######## Code reference from:
######## https://iliatimofeev.github.io/altair-viz.github.io/gallery/multiline_tooltip.html

data = pd.read_csv("combine_avgsm.csv")
data['household'] = data['household'].astype('category')
data['Date']= pd.to_datetime(data['Date'])

# Create a selection that chooses the nearest point & selects based on x-value
nearest = alt.selection(type='single', nearest=True, on='mouseover',
                        fields=['Date'], empty='none')

# The basic line
line = alt.Chart().mark_line(interpolate='basis').encode(
    x='Date:T',
    y='avg_powerallphases:Q',
    color='household:N'
).properties(
    title='Average sum of real power(Hz) over all power phases per second in a day'
)

# Transparent selectors across the chart. This is what tells us
# the x-value of the cursor
selectors = alt.Chart().mark_point().encode(
    x='Date',
    opacity=alt.value(0),
).add_selection(
    nearest
)

# Draw points on the line, and highlight based on selection
points = line.mark_point().encode(
    opacity=alt.condition(nearest, alt.value(1), alt.value(0))
)

# Draw text labels near the points, and highlight based on selection
text = line.mark_text(align='left', dx=5, dy=-5).encode(
    text=alt.condition(nearest, 'avg_powerallphases:Q', alt.value(' '))
)
text2 = line.mark_text(align='right', dx=20, dy=-20).encode(
    text=alt.condition(nearest, 'Date:T', alt.value(' '))
)
# Draw a rule at the location of the selection
rules = alt.Chart().mark_rule(color='gray').encode(
    x='Date:T',
).transform_filter(
    nearest
)

# Put the five layers into a chart and bind the data
chart=alt.layer(line, selectors, points, rules, text,text2,
          data=data, width=600, height=400)

chart.save('altair.html')
