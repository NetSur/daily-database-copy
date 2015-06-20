# odoo8_daily_database_copy

Copy Script Odoo v8 database for Ubuntu 14.04 Trusty Tahr

# Installation:

Preinstalled requisites:

Odoo:

You can view a very good tutorial to install odoo from <a href="http://www.theopensourcerer.com/2014/09/how-to-install-openerp-odoo-8-on-ubuntu-server-14-04-lts">opensourcerer </a>

pg_dump:

    sudo apt-get install postgresql-client-common

7z:

    sudo apt-get install p7zip

Make it executable with:

    chmod 755 DailyCopy.sh

Copy DailyCopy.sh to your desired path and change the "copy_path" variable with the path of your desired path

Make sure you have created "destination" folder to make the copy and that odoo user has permissions to write in it

Edit crontab of odoo user with "crontab -e" and add the line

    "0 0 * * * /path/DailyCopy.sh ddbb destination odoo_user password"  

This make a daily copy of your database at 00:00, the first number are minutes (from 0 to 60) and the second numbers are hour (from 0 to 23)

If you have more than one database, add a crontab line to each database

