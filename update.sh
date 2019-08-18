#!/usr/bin/env bash
CITY_TAR_LINK="http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"
COUNTRY_TAR_LINK="http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz"
CITY_TAR="city.tar.gz"
COUNTRY_TAR="country.tar.gz"
CITY_TMP="city-tmp"
COUNTRY_TMP="country-tmp"
BOOL_UPDATED=false

echo "Getting the latest GeoLite2-City database"
if [ -x "$(command -v wget)" ]; then
	wget $CITY_TAR_LINK -q --show-progress -O $CITY_TAR
	echo "Done. Now getting the latest GeoLite2-Country database"
	wget $COUNTRY_TAR_LINK -q --show-progress -O $COUNTRY_TAR
	BOOL_UPDATED=true
elif [ -x "$(command -v curl)" ]; then
	curl $CITY_TAR_LINK -q -o $CITY_TAR
	echo "Done. Now getting the latest GeoLite2-Country database"
	curl $COUNTRY_TAR_LINK -q -o $COUNTRY_TAR
	BOOL_UPDATED=true
fi

if [ "$BOOL_UPDATED" ]; then
	echo "Unpacking"
	mkdir $CITY_TMP
	mkdir $COUNTRY_TMP
	tar -zxf $CITY_TAR -C $CITY_TMP
	tar -zxf $COUNTRY_TAR -C $COUNTRY_TMP
	cp $CITY_TMP/$(ls $CITY_TMP/|head -n 1)/*.mmdb city.mmdb
	cp $COUNTRY_TMP/$(ls $COUNTRY_TMP/|head -n 1)/*.mmdb country.mmdb
	echo "Cleaning up"
	rm $CITY_TAR
	rm $COUNTRY_TAR
	rm -rf $CITY_TMP
	rm -rf $COUNTRY_TMP
	echo "Done with the update. Please remember to issue a new release on github (and refresh packagist if needed)"
else
	echo "Error downloading the file"
fi
