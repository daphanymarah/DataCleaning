SELECT PropertyAddress 
FROM Nashville n 
--Separating property address
SELECT 
SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, '/')-1)  AS Address
, SUBSTRING(PropertyAddress, INSTR(PropertyAddress, '/')+1, LENGTH(PropertyAddress)) AS Address
FROM Nashville n 

ALTER TABLE Nashville 
ADD PropertySplitAddress Nvarchar(255);

UPDATE Nashville 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, '/')-1)

ALTER TABLE Nashville 
ADD PropertySplitCity Nvarchar(255);

UPDATE Nashville 
SET PropertySplitCity = SUBSTRING(PropertyAddress, INSTR(PropertyAddress, '/')+1, LENGTH(PropertyAddress))

SELECT *
FROM Nashville n 
--Separate OwnerAddress
SELECT OwnerAddress 
FROM Nashville n 

SELECT 
SUBSTRING(OwnerAddress, 1, INSTR(OwnerAddress, '/') -1) AS OwnerAdressSep 
,SUBSTRING(OwnerAddress, -2) AS OwnerState
FROM Nashville n 

ALTER TABLE Nashville 
ADD OwnerAdressSep  Nvarchar(255);

UPDATE Nashville 
SET OwnerAdressSep = SUBSTRING(OwnerAddress, 1, INSTR(OwnerAddress, '/') -1) 

ALTER TABLE Nashville 
ADD OwnerState

UPDATE Nashville 
SET OwnerState = SUBSTRING(OwnerAddress, -2)

--Change Y and N to Yes and No
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant) 
FROM Nashville n 
GROUP BY SoldAsVacant 
ORDER BY 2

SELECT SoldAsVacant 
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant 
	END
FROM Nashville n 

UPDATE Nashville 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant 
	END
	
--Remove Duplicates
	WITH RowNumCTE AS(
	SELECT *,
	ROW_NUMBER () OVER(
	PARTITION BY ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
				) AS row_num
FROM Nashville n 
)
--Only deleted as practice, shouldn't delete info w/o permission
DELETE 
FROM Nashville 
WHERE row_num > 1

--Delete Unused Columns
ALTER TABLE Nashville 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

