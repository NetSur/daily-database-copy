#!/bin/bash

# Script that copy an Odoo database to a destination in yyyy/mm/dd folder format

# Usage: DailyCopy.sh Database Destination OdooUser Password
#
# Where:
#   Database: The database to copy
#   Destination: Destination of the backup
#   OdooUser: Odoo user
#   Password: To encrypt the copy in .7z format

# Installation:
#
# Preinstalled requisites: Odoo, pg_dump, 7z
#
# Make it executable with:
# chmod 755 DailyCopy.sh
#
# Copy DailyCopy.sh to your desired path and change the "copy_path" variable
# with the path of your desired path
# 
# Make sure you have created "destination" folder and odoo user has permissions
#
# Edit crontab of odoo user with "crontab -e" and add the line 
# "0 0 * * * /path/DailyCopy.sh ddbb destination odoo_user password" to make a
# daily copy of your database at 00:00, the first number are minutes (from 0 to
# 60) and the second numbers are hour (from 0 to 23)
#
# If you have more than one database, add a crontab line to each database

function daily_copy ()
{

#Parameters
ddbb=$1           # Database to copy
destination=$2    # Path to copy database in sql format
odoo_user=$3      # Odoo database user
password=$4       # Password to encript the .sql file

#Variables
year=$(date +%Y)  # Year in 4 digits format
month=$(date +%B) # Month in name format
day=$(date +%d)   # Day in 2 digits format

# Test if exists destination folder, if not create it
if [ ! -d $destination ]
   then
     mkdir $destination
fi

if [ -d $destination/$year ];                 # If already exist year folder
   then
       if [ -d $destination/$year/$month ];        # If already exist month folder
          then
            if [ -d $destination/$year/$month/$day ]; # If already exist day folder
               then
                 destination=$destination/$year/$month/$day
                 pg_dump -U $odoo_user -f $destination/$ddbb.sql $ddbb
                 7z -p$password a $destination/$ddbb.sql.7z $destination/$ddbb.sql
               else
                 mkdir $destination/$year/$month/$day # If not exist day folder, create it
                 daily_copy $ddbb $destination $odoo_user $password
            fi 
          else
            mkdir $destination/$year/$month        # If not exist month folder, create it
            daily_copy $ddbb $destination $odoo_user $password
       fi
   else
     mkdir $destination/$year                 # If not exist year folder, create it
     daily_copy $ddbb $destination $odoo_user $password
fi
}

daily_copy $1, $2, $3, $4
