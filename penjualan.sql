-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 17, 2024 at 05:53 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `penjualan`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(10) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `kode` varchar(200) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `harga` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `kode`, `keterangan`, `harga`) VALUES
(1, 'pepsodent', '', NULL, 0),
(2, 'es krim', '', NULL, 8000),
(3, 'anggur', '', NULL, 9000);

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `BarangStokInsert` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
INSERT INTO stok (id_barang,jumlah) VALUES (new.id_barang, 0);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambahBarang` AFTER INSERT ON `barang` FOR EACH ROW begin
insert into logs (pesan, tanggal) VALUES (CONCAT('Sebuah item baru sudah Ditambahkan pada table barang dengan nama',new.nama_barang,'dengan id_barang = ', new.id_barang, 'dengan harga satuan sebesar ',new.harga), current_timestamp());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `beli`
--

CREATE TABLE `beli` (
  `Id_beli` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah_beli` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `harga` int(10) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `beli`
--

INSERT INTO `beli` (`Id_beli`, `id_barang`, `jumlah_beli`, `tanggal`, `harga`, `total`) VALUES
(1, 1, 3, '0000-00-00', 40000, 0),
(2, 2, 2, '0000-00-00', 16000, 0);

--
-- Triggers `beli`
--
DELIMITER $$
CREATE TRIGGER `BeliStok` AFTER INSERT ON `beli` FOR EACH ROW BEGIN
UPDATE stok SET jumlah = jumlah + new.jumlah_beli WHERE id_barang =
new.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TRbeliLogs` AFTER INSERT ON `beli` FOR EACH ROW begin
insert into logs (pesan,tanggal) VALUES(concat('Aktifitas Pembelian untuk barang ',(select br.nama_barang from barang br where br.id_barang = new.id_barang)," dengan jumlah pembelian sebanyak ",new.jumlah_beli,' dengan harga satuan sebesar ',new.harga,' dan total biaya sebesar ',new.total,' sudah dilakukan pada tanggal   ',current_timestamp()),current_timestamp());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jual`
--

CREATE TABLE `jual` (
  `Id_jual` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah_jual` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `harga` int(10) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `jual`
--
DELIMITER $$
CREATE TRIGGER `JualStok` AFTER INSERT ON `jual` FOR EACH ROW BEGIN
UPDATE stok SET jumlah = jumlah - new.jumlah_jual WHERE id_barang =
new.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TRJualLogs` AFTER INSERT ON `jual` FOR EACH ROW begin
insert into logs (pesan, tanggal) values (concat('Aktifitas penjualan untuk barang',(select br.nama_barang from barang as br WHERE br.id_barang = new.id_barang)," dengan jumlah penjualan sebanyak ", new.jumlah_jual,' dengan harga satuan sebesar ',new.harga,' dan total biaya sebesar ',new.total,' sudah dilakukan pada tanggal ', current_timestamp()),current_timestamp());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id_logs` int(10) NOT NULL,
  `pesan` varchar(255) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id_logs`, `pesan`, `tanggal`) VALUES
(1, 'Sebuah item baru sudah Ditambahkan pada table barang dengan namaanggurdengan id_barang = 3dengan harga satuan sebesar 9000', '2024-02-17');

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `id_stok` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`id_stok`, `id_barang`, `jumlah`) VALUES
(1, 1, 3),
(2, 2, 2),
(3, 3, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `beli`
--
ALTER TABLE `beli`
  ADD PRIMARY KEY (`Id_beli`),
  ADD KEY `beli_ibfk_1` (`id_barang`);

--
-- Indexes for table `jual`
--
ALTER TABLE `jual`
  ADD PRIMARY KEY (`Id_jual`),
  ADD KEY `jual_ibfk_1` (`id_barang`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id_logs`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`id_stok`),
  ADD UNIQUE KEY `id_barang` (`id_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `beli`
--
ALTER TABLE `beli`
  MODIFY `Id_beli` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jual`
--
ALTER TABLE `jual`
  MODIFY `Id_jual` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id_logs` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stok`
--
ALTER TABLE `stok`
  MODIFY `id_stok` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `beli`
--
ALTER TABLE `beli`
  ADD CONSTRAINT `beli_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `jual`
--
ALTER TABLE `jual`
  ADD CONSTRAINT `jual_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `stok_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
