#!/usr/bin/env bash

# Configure the script to exit immediately if any command fails:
set -e


# Download WordPress core files if they're not already present:
if [ ! -f "wp-load.php" ]; then
	wp core download
else
	echo "WordPress files are already present."
fi


# Create a wp-config.php file if it's not already present:
if [ ! -f "wp-config.php" ]; then
	echo "Please enter your database credentials:"
	wp config create --prompt
fi


# Install WordPress if it isn't already:
if ! $(wp core is-installed); then
	echo "Please enter your WordPress installation details:"
	wp core install --prompt
else
	echo "WordPress is already installed."
fi


# Install some of our favourite plugins all at once:
echo "Installing plugins..."
wp plugin install jetpack wp-super-cache contact-form-7 wordpress-seo user-switching


# Activate and configure a few plugins:
echo "Configuring plugins..."
wp plugin activate wordpress-seo
wp option patch update wpseo_titles metadesc-home-wpseo "My new website"

# Create a child theme that we can start working on:
wp theme list
echo "Please enter your child theme details:"
wp scaffold child-theme --prompt


# Install the wp-admin package if it isn't already:
if ! $(wp cli has-command admin); then
	echo "Installing some WP-CLI packages..."
	wp package install wp-cli/admin-command
else
	echo "Package wp-admin is already installed."
fi


# Let's go!
echo "Done!"
wp admin

