select *
from PortfolioProject..NashvilleHousing


--sales date

select SaleDate, covert(date, SaleDate)
from PortfolioProject..NashvilleHousing


update NashvilleHousing
set SaleDate = convert(date, SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

update NashvilleHousing
set SaleDate = convert(date, SaleDate)


select SaleDateConverted, convert(date, SaleDate)
from PortfolioProject..NashvilleHousing

--populate property address

select *
from PortfolioProject..NashvilleHousing
--where propertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqeID] <> b.[UniqeID]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, 'NoAddress')
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqeID] <> b.[UniqeID]
where a.PropertyAddress is null


--Breaking Address into colummns(Address, City, State)


select PropertyAddress
from PortfolioProject..NashvilleHousing
--where propertyAddress is null
--order by ParcelID

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress, -1)) as Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing
--where propertyAddress is null
--order by ParcelID