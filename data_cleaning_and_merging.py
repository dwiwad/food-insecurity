#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 27 18:34:26 2018

Cleaning and Merging the 12 data files to explore food insecurity and ineq.

@author: dylanwiwad
"""
import pandas as pd

# Bring in the inequality data files; they are long format with cols for yr
gini_2010 = pd.read_csv("2010_gini.csv")
gini_2011 = pd.read_csv("2011_gini.csv")
gini_2012 = pd.read_csv("2012_gini.csv")
gini_2013 = pd.read_csv("2013_gini.csv")
gini_2014 = pd.read_csv("2014_gini.csv")
gini_2015 = pd.read_csv("2015_gini.csv")
gini_2016 = pd.read_csv("2016_gini.csv")

# In order to avoid some messiness later, I'm going to trim columns now\
cols = ['year', 'fips', 'gini']
gini_2010 = gini_2010[cols]
gini_2011 = gini_2011[cols]
gini_2012 = gini_2012[cols]
gini_2013 = gini_2013[cols]
gini_2014 = gini_2014[cols]
gini_2015 = gini_2015[cols]
gini_2016 = gini_2016[cols]


# Bring in the food insecurity data; same long format with a yr col
fi_2010 = pd.read_csv("2010_FI.csv")
fi_2011 = pd.read_csv("2011_FI.csv")
fi_2012 = pd.read_csv("2012_FI.csv")
fi_2013 = pd.read_csv("2013_FI.csv")
fi_2014 = pd.read_csv("2014_FI.csv")
fi_2015 = pd.read_csv("2015_FI.csv")
fi_2016 = pd.read_csv("2016_FI.csv")

# In order to avoid some messiness later, I'm going to trim columns now\
cols = ['FIPS', 'FI_rate', 'num_FI', 'FI_child', 'num_child']
fi_2010 = fi_2010[cols]
fi_2011 = fi_2011[cols]
fi_2012 = fi_2012[cols]
fi_2013 = fi_2013[cols]
fi_2014 = fi_2014[cols]
fi_2015 = fi_2015[cols]
fi_2016 = fi_2016[cols]

# Need to recode this stupid fips columns names
fi_2010 = fi_2010.rename(columns={'FIPS': 'fips'})
fi_2011 = fi_2011.rename(columns={'FIPS': 'fips'})
fi_2012 = fi_2012.rename(columns={'FIPS': 'fips'})
fi_2013 = fi_2013.rename(columns={'FIPS': 'fips'})
fi_2014 = fi_2014.rename(columns={'FIPS': 'fips'})
fi_2015 = fi_2015.rename(columns={'FIPS': 'fips'})
fi_2016 = fi_2016.rename(columns={'FIPS': 'fips'})


# Merge each of the yearly gini and fi files
merge_2010 = pd.merge(gini_2010, fi_2010, on = 'fips')
merge_2011 = pd.merge(gini_2011, fi_2011, on = 'fips')
merge_2012 = pd.merge(gini_2012, fi_2012, on = 'fips')
merge_2013 = pd.merge(gini_2013, fi_2013, on = 'fips')
merge_2014 = pd.merge(gini_2014, fi_2014, on = 'fips')
merge_2015 = pd.merge(gini_2015, fi_2015, on = 'fips')
merge_2016 = pd.merge(gini_2016, fi_2016, on = 'fips')

merged_long = pd.concat([merge_2010, merge_2011, merge_2012, merge_2013,
                         merge_2014, merge_2015, merge_2016])

# Write the file
merged_long.to_csv('merged_long.csv')

#--------------------------------------------------------------------------
# I need to merge them wide as well. Let's change the column names
#--------------------------------------------------------------------------

# Gini
gini_2010 = gini_2010.rename(columns={'gini': 'gini_2010'})
gini_2011 = gini_2011.rename(columns={'gini': 'gini_2011'})
gini_2012 = gini_2012.rename(columns={'gini': 'gini_2012'})
gini_2013 = gini_2013.rename(columns={'gini': 'gini_2013'})
gini_2014 = gini_2014.rename(columns={'gini': 'gini_2014'})
gini_2015 = gini_2015.rename(columns={'gini': 'gini_2015'})
gini_2016 = gini_2016.rename(columns={'gini': 'gini_2016'})

# Food insecurity
fi_2010 = fi_2010.rename(columns={'FI_rate': 'FI_rate_2010',
                                  'num_FI': 'num_FI_2010',
                                  'FI_child': 'FI_child_2010',
                                  'num_child': 'num_child_2010'})
fi_2011 = fi_2011.rename(columns={'FI_rate': 'FI_rate_2011',
                                  'num_FI': 'num_FI_2011',
                                  'FI_child': 'FI_child_2011',
                                  'num_child': 'num_child_2011'})
fi_2012 = fi_2012.rename(columns={'FI_rate': 'FI_rate_2012',
                                  'num_FI': 'num_FI_2012',
                                  'FI_child': 'FI_child_2012',
                                  'num_child': 'num_child_2012'})
fi_2013 = fi_2013.rename(columns={'FI_rate': 'FI_rate_2013',
                                  'num_FI': 'num_FI_2013',
                                  'FI_child': 'FI_child_2013',
                                  'num_child': 'num_child_2013'})
fi_2014 = fi_2014.rename(columns={'FI_rate': 'FI_rate_2014',
                                  'num_FI': 'num_FI_2014',
                                  'FI_child': 'FI_child_2014',
                                  'num_child': 'num_child_2014'})
fi_2015 = fi_2015.rename(columns={'FI_rate': 'FI_rate_2015',
                                  'num_FI': 'num_FI_2015',
                                  'FI_child': 'FI_child_2015',
                                  'num_child': 'num_child_2015'})
fi_2016 = fi_2016.rename(columns={'FI_rate': 'FI_rate_2016',
                                  'num_FI': 'num_FI_2016',
                                  'FI_child': 'FI_child_2016',
                                  'num_child': 'num_child_2016'})

# Merge together the gini files
gini_wide = reduce(lambda left,right: pd.merge(left,right, on='fips'), ginis)

# Clean it up a bit, dropping the redundant columns
cols = ['fips', 'gini_2010', 'gini_2011', 'gini_2012',
        'gini_2013', 'gini_2014', 'gini_2015', 'gini_2016']
gini_wide = gini_wide[cols]
gini_wide['county'] = gini_2010['county']

# Merging wide the fi data    
fi_wide = reduce(lambda left,right: pd.merge(left, right, on='fips'), fis)

# Clean it up a bit, dropping the redundant columns and just taking what
# I care about for now.
cols = ['fips', 'FI_rate_2010', 'num_FI_2010', 'FI_child_2010', 'num_child_2010',
        'FI_rate_2011', 'num_FI_2011', 'FI_child_2011', 'num_child_2011',
        'FI_rate_2012', 'num_FI_2012', 'FI_child_2012', 'num_child_2012',
        'FI_rate_2013', 'num_FI_2013', 'FI_child_2013', 'num_child_2013',
        'FI_rate_2014', 'num_FI_2014', 'FI_child_2014', 'num_child_2014',
        'FI_rate_2015', 'num_FI_2015', 'FI_child_2015', 'num_child_2015',
        'FI_rate_2016', 'num_FI_2016', 'FI_child_2016', 'num_child_2016']
fi_wide = fi_wide[cols]

# And now finally merge them into the wide format file
merged_wide = pd.merge(gini_wide, fi_wide, on = "fips")

# Write the file
merged_wide.to_csv('merged_wide.csv')








































