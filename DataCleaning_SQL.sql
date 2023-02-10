--Cleaning data in sql queries

select * from PortfolioProject.dbo.NashvilleHousing


--Standardize Data Format

select SaleDateConverted,CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;



Update NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)

---------------------------------------------------------------------------------------------------------
--populate Property Address data


select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null



update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null


-----------------------------------------------------------------------------------------------------------------


--Breaking out Address into individual columns(Address,City,State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);



Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


select * 
from PortfolioProject.dbo.NashvilleHousing


select OwnerAddress 
from PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(replace(OwnerAddress,',','.'),3)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);



Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);



Update NashvilleHousing
SET OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),1)


-----------------------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE when SoldAsVacant=1 then 'Yes'
      when SoldAsVacant=0 then 'No'
	  END
from PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------

--remove Duplicates

with RowNumCTE as(
select * ,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				     UniqueID
					 )row_num

from PortfolioProject.dbo.NashvilleHousing
)
Delete
from RowNumCTE
where row_num>1




with RowNumCTE as(
select * ,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				     UniqueID
					 )row_num

from PortfolioProject.dbo.NashvilleHousing
)
select *
from RowNumCTE
where row_num>1
order by PropertyAddress


---------------------------------------------------------------------------------------------------------------------

--Delete unused columns



select *
from PortfolioProject.dbo.NashvilleHousing



Alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate


------------------------------------------------------------------------------------------------------------------

-- exclude the null values from the table

SELECT OwnerName
 FROM PortfolioProject.dbo.NashvilleHousing
WHERE OwnerName IS NOT NULL;


SELECT * FROM PortfolioProject.dbo.NashvilleHousing
WHERE OwnerName IS NOT NULL
AND Acreage IS NOT NULL
AND BuildingValue IS NOT NULL
AND TotalValue IS NOT NULL
AND YearBuilt IS NOT NULL
AND Bedrooms IS NOT NULL
AND FullBath IS NOT NULL
AND HalfBath IS NOT NULL
AND OwnerSplitAddress IS NOT NULL
AND OwnerSplitCity IS NOT NULL
AND OwnerSplitState IS NOT NULL
AND LandValue IS NOT NULL;


--or

UPDATE [NashvilleHousing]
SET [OwnerName]='No Name'
WHERE [OwnerName] IS NULL;