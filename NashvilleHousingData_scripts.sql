-- Cleaning data in SQL Queries
select saledate from nashville_data;

--------------------------------------------------------------------------

-- Populate property address data
select *
from nashville_data
where propertyaddress is null
ORDER BY parcelid;

-- Self-join the table in order to fill up the null propertyaddress column
-- based on parcelid
select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress,
		COALESCE(a.propertyaddress, b.propertyaddress)
from nashville_data a
inner join nashville_data b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null;

-- update those null property address;
update nashville_data a
set propertyaddress = b.propertyaddress
from nashville_data b
where a.propertyaddress is null and a.parcelid = b.parcelid and a.uniqueid <> b.uniqueid;


-- Breaking out address into individual column (address, city, state)
select 
	substring(propertyaddress, 1, POSITION(',' in propertyaddress)-1) as address,
	substring(propertyaddress, POSITION(',' in propertyaddress)+2, LENGTH(propertyaddress)) as city
	
from nashville_data;


-- create two columns: address and city
ALTER TABLE nashville_data
ADD COLUMN PropertySplitAddress varchar,
ADD COLUMN PropertySplitCity varchar;
--
UPDATE nashville_data
SET PropertySplitAddress = substring(propertyaddress, 1, POSITION(',' in propertyaddress)-1);
--
UPDATE nashville_data
SET PropertySplitCity = substring(propertyaddress, POSITION(',' in propertyaddress)+2, LENGTH(propertyaddress));
--
select PropertySplitAddress, PropertySplitCity
from nashville_data;

-- Another method to split
select
	SPLIT_PART(owneraddress, ', ', 1) as address,
	SPLIT_PART(owneraddress, ', ', 2) as city,
	SPLIT_PART(owneraddress, ', ', 3) as state

from nashville_data
-- Create 3 columns for owner address
ALTER TABLE nashville_data
ADD COLUMN OwnerSplitAddress varchar,
ADD COLUMN OwnerSplitCity varchar,
ADD COLUMN OwnerSplitState varchar;

UPDATE nashville_data
SET OwnerSplitAddress = SPLIT_PART(owneraddress, ', ', 1),
OwnerSplitCity = SPLIT_PART(owneraddress, ', ', 2),
OwnerSplitState = SPLIT_PART(owneraddress, ', ', 3);
--
Select * from nashville_data;
-- Modify Y/N to Yes/No
Select Distinct(soldasvacant) from nashville_data;
--
Select soldasvacant,
CASE
	When soldasvacant = 'Y' THEN 'Yes'
	When soldasvacant = 'N'THEN 'No'
	ELSE soldasvacant
END
FROM nashville_data;
-- Update yes no
UPDATE nashville_data
SET soldasvacant = CASE
						When soldasvacant = 'Y' THEN 'Yes'
						When soldasvacant = 'N'THEN 'No'
						ELSE soldasvacant
					END;

---------------------------------------------------------------
-- Delete unused columns
ALTER TABLE nashville_data
DROP COLUMN IF EXISTS owneraddress, 
DROP COLUMN IF EXISTS taxdistrict,
DROP COLUMN IF EXISTS propertyaddress,
DROP COLUMN IF EXISTS saledate;
--------------------------------------------------------------
select * from nashville_data;





