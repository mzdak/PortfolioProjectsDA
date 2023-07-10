/*

Cleaning Data in SQL Queries

*/
select *
from NashvilleHousingData

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDateConverted, SaleDate
from NashvilleHousingData

alter table NashvilleHousingData
Add SaleDateConverted date

update NashvilleHousingData
set SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select *
from NashvilleHousingData
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousingData a
join NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousingData a
join NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
select *
from NashvilleHousingData
--where PropertyAddress is null
--order by ParcelID

		--Using substring
select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from NashvilleHousingData

Alter table NashvilleHousingData
Add PropertySplitAddress Nvarchar(255)

Alter table NashvilleHousingData
Add PropertySplitCity Nvarchar(255)

update NashvilleHousingData
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

update NashvilleHousingData
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

		--Using PARSENAME
select PARSENAME(REPLACE(OwnerAddress, ',','.'),1),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
from NashvilleHousingData

Alter table NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255), OwnerSplitCity Nvarchar(255)

update NashvilleHousingData
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

update NashvilleHousingData
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

Alter table NashvilleHousingData
Add OwnerSplitStates Nvarchar(255)

update NashvilleHousingData
set OwnerSplitStates = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousingData
group by SoldAsVacant

select SoldAsVacant,
	case when SoldAsVacant = 'Y' Then 'Yes'
		 when SoldAsVacant = 'N' Then 'No'
		 else SoldAsVacant
	end
from NashvilleHousingData

update NashvilleHousingData
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
		 when SoldAsVacant = 'N' Then 'No'
		 else SoldAsVacant
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE as(
select *, ROW_NUMBER() Over(
	Partition By ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order by UniqueID
	) row_num
from NashvilleHousingData
)
delete
from RowNumCTE
where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select *
from NashvilleHousingData

alter table NashvilleHousingData
drop column OwnerAddress, TaxDistrict, PropertyAddress