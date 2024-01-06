SELECT *
FROM [Nashville Housing Data for Data Cleaning]

--Populate PropertAddress data
SELECT PropertyAddress
FROM [Nashville Housing Data for Data Cleaning]
WHERE PropertyAddress is null


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM [Nashville Housing Data for Data Cleaning] a
Join [Nashville Housing Data for Data Cleaning] b
	ON a.ParcelID=b.ParcelID 
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

UPDATE a
SET PropertyAddressUpdate=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville Housing Data for Data Cleaning] a
Join [Nashville Housing Data for Data Cleaning] b
	ON a.ParcelID=b.ParcelID 
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


--Breaking down the address into individual columns(Address, City, State)

SELECT PropertyAddress
FROM [Nashville Housing Data for Data Cleaning]

SELECT 
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2) AS Address,
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) AS City
FROM [Nashville Housing Data for Data Cleaning];

ALTER TABLE [Nashville Housing Data For Data Cleaning]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress=PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)

ALTER TABLE [Nashville Housing Data For Data Cleaning]
ADD PropertySplitCity Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET PropertySplitCity=PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)

SELECT *
FROM [Nashville Housing Data for Data Cleaning]


--Owner Address

SELECT OwnerAddress
FROM [Nashville Housing Data for Data Cleaning]

SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM [Nashville Housing Data for Data Cleaning];

ALTER TABLE [Nashville Housing Data For Data Cleaning]
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE [Nashville Housing Data For Data Cleaning]
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE [Nashville Housing Data For Data Cleaning]
ADD OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM [Nashville Housing Data for Data Cleaning]


--Change N and Y to YES OR No in SoldAsVacant field

SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant='N' THEN 'NO'
		WHEN SoldAsVacant='Y' THEN 'YES'
		ELSE SoldAsVacant
	END 
FROM [Nashville Housing Data for Data Cleaning]

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD SoldAsVacantString VARCHAR(50);

UPDATE [Nashville Housing Data for Data Cleaning]
SET SoldAsVacantString = CASE
                            WHEN SoldAsVacant = 'N' THEN 'NO'
                            WHEN SoldAsVacant = 'Y' THEN 'YES'
                            ELSE SoldAsVacant --NULL -- or any other default value
                        END;
SELECT *
FROM [Nashville Housing Data for Data Cleaning]

ALTER TABLE [Nashville Housing Data for Data Cleaning]
DROP COLUMN PropertyAddressUpdate

SELECT *
FROM [Nashville Housing Data for Data Cleaning]

--Remove Duplicates

SELECT *
FROM [Nashville Housing Data for Data Cleaning]

WITH NHCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) AS rn
    FROM [Nashville Housing Data for Data Cleaning]
)
SELECT *
FROM NHCTE
WHERE rn > 1;

--Delete Unused Columns

SELECT *
FROM [Nashville Housing Data for Data Cleaning]


ALTER TABLE [Nashville Housing Data for Data Cleaning]
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict, SoldAsVacant

SELECT *
FROM [Nashville Housing Data for Data Cleaning]