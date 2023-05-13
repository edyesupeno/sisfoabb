-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 13 Bulan Mei 2023 pada 11.42
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laravel`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `approvals`
--

CREATE TABLE `approvals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `reference_id` bigint(20) NOT NULL,
  `requester_id` bigint(20) DEFAULT NULL,
  `requester` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requester`)),
  `meta_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta_data`)),
  `cancel_reason` varchar(255) DEFAULT NULL,
  `requested_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `done_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `approvals`
--

INSERT INTO `approvals` (`id`, `type`, `status`, `reference_id`, `requester_id`, `requester`, `meta_data`, `cancel_reason`, `requested_at`, `approved_at`, `rejected_at`, `cancelled_at`, `done_at`, `created_at`, `updated_at`) VALUES
(1, 'attendance_without_schedule', 'awaiting', 1, 21, '{\"name\":\"test\",\"branch\":\"HM\",\"designation\":\"Team Leader\"}', '{\"date\":\"2023-05-07\",\"clock_in\":\"09:59:06\",\"clock_out\":\"10:00:14\",\"address_clock_in\":\"Seputih, Jember, Jawa Timur, 68174, Indonesia\",\"address_clock_out\":\"Seputih, Jember, Jawa Timur, 68174, Indonesia\",\"notes_clock_in\":\"nsnsjsjs\",\"notes_clock_out\":\"ttg\",\"total_work_hours\":\"00:00:55\"}', NULL, '2023-05-06 20:00:23', NULL, NULL, NULL, NULL, '2023-05-06 20:00:23', '2023-05-06 20:00:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `approval_rules`
--

CREATE TABLE `approval_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `approval_type_id` bigint(20) UNSIGNED NOT NULL,
  `need_approval` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `approval_rule_levels`
--

CREATE TABLE `approval_rule_levels` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `approval_rule_id` bigint(20) UNSIGNED NOT NULL,
  `approver_type` varchar(255) NOT NULL,
  `employee_id` bigint(20) UNSIGNED DEFAULT NULL,
  `level_approval` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `approval_steps`
--

CREATE TABLE `approval_steps` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `approval_id` bigint(20) UNSIGNED NOT NULL,
  `approver_id` bigint(20) DEFAULT NULL,
  `approver` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`approver`)),
  `level` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `notified_at` timestamp NULL DEFAULT NULL,
  `void_at` timestamp NULL DEFAULT NULL,
  `done_at` timestamp NULL DEFAULT NULL,
  `rejected_reason` varchar(255) DEFAULT NULL,
  `approved_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `approval_types`
--

CREATE TABLE `approval_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `approval_types`
--

INSERT INTO `approval_types` (`id`, `label`, `type`, `group`, `created_at`, `updated_at`) VALUES
(1, 'Create Leave', 'create_leave', 'leave', '2023-05-05 22:03:28', '2023-05-05 22:03:28'),
(2, 'Attendance Without Schedule', 'attendance_without_schedule', 'attendance', '2023-05-05 22:03:28', '2023-05-05 22:03:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `area`
--

CREATE TABLE `area` (
  `id` int(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `id_branch` varchar(255) NOT NULL,
  `deleted_at` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `area`
--

INSERT INTO `area` (`id`, `nama`, `id_branch`, `deleted_at`) VALUES
(1, 'Zamrud2', '5', NULL),
(6, 'asdasd', '5', NULL),
(7, 'Zamrud', '8', NULL),
(8, 'Emas', '8', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `attendances`
--

CREATE TABLE `attendances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `is_force_clock_out` tinyint(1) NOT NULL DEFAULT 0,
  `is_offline_clock_in` tinyint(1) NOT NULL DEFAULT 0,
  `is_offline_clock_out` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `clock_in` time DEFAULT NULL,
  `clock_out` time DEFAULT NULL,
  `date_clock` date DEFAULT NULL,
  `latitude_clock_in` varchar(255) DEFAULT NULL,
  `longitude_clock_in` varchar(255) DEFAULT NULL,
  `latitude_clock_out` varchar(255) DEFAULT NULL,
  `longitude_clock_out` varchar(255) DEFAULT NULL,
  `notes_clock_in` text DEFAULT NULL,
  `notes_clock_out` text DEFAULT NULL,
  `files_clock_in` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_clock_in`)),
  `files_clock_out` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_clock_out`)),
  `image_id_clock_in` bigint(20) DEFAULT NULL,
  `image_id_clock_out` bigint(20) DEFAULT NULL,
  `address_clock_in` text DEFAULT NULL,
  `address_clock_out` text DEFAULT NULL,
  `is_outside_radius_clock_in` tinyint(1) NOT NULL DEFAULT 0,
  `is_outside_radius_clock_out` tinyint(1) NOT NULL DEFAULT 0,
  `is_need_approval_clock_in` tinyint(1) NOT NULL DEFAULT 0,
  `is_need_approval_clock_out` tinyint(1) NOT NULL DEFAULT 0,
  `clock_in_approved_at` timestamp NULL DEFAULT NULL,
  `clock_out_approved_at` timestamp NULL DEFAULT NULL,
  `clock_in_approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `clock_out_approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `is_late_clock_in` tinyint(1) NOT NULL DEFAULT 0,
  `is_early_clock_out` tinyint(1) NOT NULL DEFAULT 0,
  `total_work_hours` time DEFAULT NULL,
  `total_late_clock_in` time DEFAULT NULL,
  `total_early_clock_out` time DEFAULT NULL,
  `source_clock_in` varchar(255) DEFAULT NULL,
  `reference_clock_in` varchar(255) DEFAULT NULL,
  `source_clock_out` varchar(255) DEFAULT NULL,
  `reference_clock_out` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `attendances`
--

INSERT INTO `attendances` (`id`, `is_force_clock_out`, `is_offline_clock_in`, `is_offline_clock_out`, `user_id`, `status`, `clock_in`, `clock_out`, `date_clock`, `latitude_clock_in`, `longitude_clock_in`, `latitude_clock_out`, `longitude_clock_out`, `notes_clock_in`, `notes_clock_out`, `files_clock_in`, `files_clock_out`, `image_id_clock_in`, `image_id_clock_out`, `address_clock_in`, `address_clock_out`, `is_outside_radius_clock_in`, `is_outside_radius_clock_out`, `is_need_approval_clock_in`, `is_need_approval_clock_out`, `clock_in_approved_at`, `clock_out_approved_at`, `clock_in_approved_by`, `clock_out_approved_by`, `is_late_clock_in`, `is_early_clock_out`, `total_work_hours`, `total_late_clock_in`, `total_early_clock_out`, `source_clock_in`, `reference_clock_in`, `source_clock_out`, `reference_clock_out`, `created_at`, `updated_at`) VALUES
(1, 0, 0, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 0, 1, 1, 23, 'wfo', '09:59:06', '10:00:14', '2023-05-07', '-8.2355779', '113.7616311', '-8.2355778', '113.7616313', 'nsnsjsjs', 'ttg', '[]', '[]', 2, 3, 'Seputih, Jember, Jawa Timur, 68174, Indonesia', 'Seputih, Jember, Jawa Timur, 68174, Indonesia', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 0, '00:00:55', '00:00:00', '00:00:00', NULL, NULL, NULL, NULL, '2023-05-06 20:00:23', '2023-05-06 20:00:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `attendance_offline_logs`
--

CREATE TABLE `attendance_offline_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `is_offline_clock_in` tinyint(1) NOT NULL DEFAULT 0,
  `is_offline_clock_out` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `clock_in` time DEFAULT NULL,
  `clock_out` time DEFAULT NULL,
  `date_clock` date DEFAULT NULL,
  `latitude_clock_in` varchar(255) DEFAULT NULL,
  `longitude_clock_in` varchar(255) DEFAULT NULL,
  `latitude_clock_out` varchar(255) DEFAULT NULL,
  `longitude_clock_out` varchar(255) DEFAULT NULL,
  `image_id_clock_in` bigint(20) DEFAULT NULL,
  `image_id_clock_out` bigint(20) DEFAULT NULL,
  `files_clock_in` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_clock_in`)),
  `files_clock_out` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_clock_out`)),
  `notes_clock_in` text DEFAULT NULL,
  `notes_clock_out` text DEFAULT NULL,
  `address_clock_in` text DEFAULT NULL,
  `address_clock_out` text DEFAULT NULL,
  `total_work_hours` time DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `reject_reason` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source_clock_in` varchar(255) DEFAULT NULL,
  `reference_clock_in` varchar(255) DEFAULT NULL,
  `source_clock_out` varchar(255) DEFAULT NULL,
  `reference_clock_out` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `attendance_offline_logs`
--

INSERT INTO `attendance_offline_logs` (`id`, `is_offline_clock_in`, `is_offline_clock_out`, `user_id`, `clock_in`, `clock_out`, `date_clock`, `latitude_clock_in`, `longitude_clock_in`, `latitude_clock_out`, `longitude_clock_out`, `image_id_clock_in`, `image_id_clock_out`, `files_clock_in`, `files_clock_out`, `notes_clock_in`, `notes_clock_out`, `address_clock_in`, `address_clock_out`, `total_work_hours`, `status`, `reject_reason`, `type`, `source_clock_in`, `reference_clock_in`, `source_clock_out`, `reference_clock_out`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 23, '09:59:06', '10:00:14', '2023-05-07', '-8.2355779', '113.7616311', '-8.2355778', '113.7616313', 2, 3, '[]', '[]', 'nsnsjsjs', 'ttg', 'Seputih, Jember, Jawa Timur, 68174, Indonesia', 'Seputih, Jember, Jawa Timur, 68174, Indonesia', '00:00:55', 'approved', NULL, 'wfo', NULL, NULL, NULL, NULL, '2023-05-06 19:59:14', '2023-05-06 20:00:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `bpjsk_settings`
--

CREATE TABLE `bpjsk_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `registration_number` varchar(255) DEFAULT NULL,
  `bpjs_office` varchar(255) DEFAULT NULL,
  `minimum_value` int(11) DEFAULT NULL,
  `valid_month` date NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bpjstk_components`
--

CREATE TABLE `bpjstk_components` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key_name` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `company_precentage` decimal(8,2) NOT NULL,
  `employee_precentage` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `bpjstk_components`
--

INSERT INTO `bpjstk_components` (`id`, `key_name`, `name`, `company_precentage`, `employee_precentage`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'old_age', 'Jaminan Hari Tua', '3.70', '2.00', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(2, 'life_insurance', 'Jaminan Kematian', '0.30', '0.00', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(3, 'pension_time', 'Jaminan Pensiun', '2.00', '1.00', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `bpjstk_risk_levels`
--

CREATE TABLE `bpjstk_risk_levels` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `precentage` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `bpjstk_risk_levels`
--

INSERT INTO `bpjstk_risk_levels` (`id`, `name`, `precentage`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Sangat Rendah', '0.24', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(2, 'Rendah', '0.54', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(3, 'Sedang', '0.89', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(4, 'Tinggi', '1.27', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(5, 'Sangat Tinggi', '1.74', '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `bpjstk_settings`
--

CREATE TABLE `bpjstk_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `registration_number` varchar(255) DEFAULT NULL,
  `bpjs_office` varchar(255) DEFAULT NULL,
  `minimum_value` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `valid_month` date NOT NULL,
  `bpjstk_risk_level_id` bigint(20) UNSIGNED DEFAULT NULL,
  `old_age` tinyint(1) NOT NULL DEFAULT 0,
  `life_insurance` tinyint(1) NOT NULL DEFAULT 0,
  `pension_time` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `branches`
--

CREATE TABLE `branches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `telegram_chat_id` varchar(255) DEFAULT NULL,
  `manager` varchar(255) NOT NULL,
  `nohp` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `zip_code` varchar(255) NOT NULL,
  `latitude` varchar(255) NOT NULL,
  `longitude` varchar(255) NOT NULL,
  `radius` int(11) NOT NULL,
  `timezone` varchar(255) DEFAULT 'Asia/Jakarta',
  `radius_tracker` int(11) DEFAULT NULL,
  `tracker_interval` time DEFAULT NULL,
  `npwp_list_id` bigint(20) UNSIGNED NOT NULL DEFAULT 1,
  `tanggal` varchar(255) NOT NULL,
  `tanggal_akhir` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `branches`
--

INSERT INTO `branches` (`id`, `telegram_chat_id`, `manager`, `nohp`, `name`, `address`, `state`, `city`, `zip_code`, `latitude`, `longitude`, `radius`, `timezone`, `radius_tracker`, `tracker_interval`, `npwp_list_id`, `tanggal`, `tanggal_akhir`, `created_at`, `updated_at`, `deleted_at`, `status`, `type`) VALUES
(1, NULL, '3', '', 'HQ', 'Jl Dummy', 'Jawa Tengah', 'Semarang', '52212', '-5.836311069120119', '112.66920386677617', 500, 'Asia/Jakarta', NULL, NULL, 1, '', '', '2023-05-05 22:03:21', '2023-05-09 10:23:28', '2023-05-09 10:23:28', 'tidak aktif', ''),
(2, NULL, '4', '', 'HM', 'Jl Dummy', 'Jawa Tengah', 'Semarang', '52212', '-5.836311069120119', '112.66920386677617', 500, 'Asia/Jakarta', NULL, NULL, 1, '', '', '2023-05-05 22:03:21', '2023-05-09 10:25:24', '2023-05-09 10:25:24', 'aktif', ''),
(4, NULL, '4', '+6285156898315', 'Test Project', 'Jl Dummy', 'Jawa Timur', 'Jember', '500', '-118812912912', '4423432324', 233, 'Asia/Jakarta', NULL, NULL, 1, '2023-05-10', '2023-05-26', '2023-05-09 09:31:47', '2023-05-09 10:31:41', '2023-05-09 10:31:41', 'Aktif', NULL),
(5, NULL, '9', '3232432', 'Kecil', 'sadasd', 'asdasd', 'asdsad', '2121', '-5.836311069120119', '112.66920386677617', 2231, 'Asia/Jakarta', NULL, NULL, 1, '2023-05-03', '2023-05-27', '2023-05-09 09:56:33', '2023-05-11 22:50:52', NULL, 'Aktif', 'Project'),
(6, NULL, '10', '+6273712113121', 'Test dua', 'Jl Dummy', 'Jawa Timur', 'Jember', '121212', '831193121', '-831193121', 500, 'Asia/Jakarta', NULL, NULL, 1, '2023-05-01', '2023-05-31', '2023-05-09 20:31:43', '2023-05-09 20:32:05', '2023-05-09 20:32:05', 'Aktif', 'Project'),
(7, NULL, '4', '+623232432', 'Testdua', 'Jl Dummy', 'Jawa Timur', 'Jember', '21321', '332234', '32432', 2231, 'Asia/Jakarta', NULL, NULL, 1, '2023-05-01', '2023-05-31', '2023-05-09 20:33:43', '2023-05-09 20:34:02', '2023-05-09 20:34:02', 'Aktif', 'Project'),
(8, NULL, '12', '08888312121', 'Besar', 'asddas', 'asdasd', 'sadads', '2121', '332234', '32432', 233, 'Asia/Jakarta', NULL, NULL, 1, '2023-05-01', '2023-05-25', '2023-05-12 22:48:23', '2023-05-12 22:48:23', NULL, 'Aktif', 'Project');

--
-- Trigger `branches`
--
DELIMITER $$
CREATE TRIGGER `generatecode` AFTER INSERT ON `branches` FOR EACH ROW BEGIN

INSERT INTO `struktur` (`id`, `kode`, `pegawai_id`, `jabatan_id`, `id_area`, `schedule`) VALUES (NULL, CONCAT(NEW.id,','), NEW.manager, '1', NULL, 'non shift');

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `breaks`
--

CREATE TABLE `breaks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `attendance_id` bigint(20) UNSIGNED NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `total_work_hours` time DEFAULT NULL,
  `latitude_start_break` varchar(255) DEFAULT NULL,
  `longitude_start_break` varchar(255) DEFAULT NULL,
  `latitude_end_break` varchar(255) DEFAULT NULL,
  `longitude_end_break` varchar(255) DEFAULT NULL,
  `address_start_break` varchar(255) DEFAULT NULL,
  `address_end_break` varchar(255) DEFAULT NULL,
  `note_start_break` varchar(255) DEFAULT NULL,
  `note_end_break` varchar(255) DEFAULT NULL,
  `image_id_start_break` bigint(20) DEFAULT NULL,
  `image_id_end_break` bigint(20) DEFAULT NULL,
  `files_start_break` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_start_break`)),
  `files_end_break` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_end_break`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `breaks`
--

INSERT INTO `breaks` (`id`, `attendance_id`, `start_time`, `end_time`, `total_work_hours`, `latitude_start_break`, `longitude_start_break`, `latitude_end_break`, `longitude_end_break`, `address_start_break`, `address_end_break`, `note_start_break`, `note_end_break`, `image_id_start_break`, `image_id_end_break`, `files_start_break`, `files_end_break`, `created_at`, `updated_at`) VALUES
(1, 2, '10:00:01', '10:00:14', '00:00:13', NULL, NULL, '-8.2355778', '113.7616313', NULL, 'Seputih, Jember, Jawa Timur, 68174, Indonesia', NULL, 'ttg', NULL, 3, NULL, NULL, '2023-05-06 20:00:23', '2023-05-06 20:00:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `break_offline_attendances`
--

CREATE TABLE `break_offline_attendances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `attendance_offline_log_id` bigint(20) UNSIGNED NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `total_work_hours` time DEFAULT NULL,
  `latitude_start_break` varchar(255) DEFAULT NULL,
  `longitude_start_break` varchar(255) DEFAULT NULL,
  `latitude_end_break` varchar(255) DEFAULT NULL,
  `longitude_end_break` varchar(255) DEFAULT NULL,
  `address_start_break` varchar(255) DEFAULT NULL,
  `address_end_break` varchar(255) DEFAULT NULL,
  `note_start_break` varchar(255) DEFAULT NULL,
  `note_end_break` varchar(255) DEFAULT NULL,
  `image_id_start_break` bigint(20) DEFAULT NULL,
  `image_id_end_break` bigint(20) DEFAULT NULL,
  `files_start_break` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_start_break`)),
  `files_end_break` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`files_end_break`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `break_offline_attendances`
--

INSERT INTO `break_offline_attendances` (`id`, `attendance_offline_log_id`, `start_time`, `end_time`, `total_work_hours`, `latitude_start_break`, `longitude_start_break`, `latitude_end_break`, `longitude_end_break`, `address_start_break`, `address_end_break`, `note_start_break`, `note_end_break`, `image_id_start_break`, `image_id_end_break`, `files_start_break`, `files_end_break`, `created_at`, `updated_at`) VALUES
(1, 1, '10:00:01', '10:00:14', '00:00:13', NULL, NULL, '-8.2355778', '113.7616313', NULL, 'Seputih, Jember, Jawa Timur, 68174, Indonesia', NULL, 'ttg', NULL, 3, '[]', '[]', '2023-05-06 20:00:02', '2023-05-06 20:00:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `company_informations`
--

CREATE TABLE `company_informations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `logo` bigint(20) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT 'BeetleHr',
  `name` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `company_informations`
--

INSERT INTO `company_informations` (`id`, `logo`, `company_name`, `name`, `address`, `email`, `phone_number`, `created_at`, `updated_at`, `deleted_at`, `status`) VALUES
(1, 8, 'ERP ABB', 'ERP ABB', '-', 'developer@beetlehr.com', '-', '2023-05-10 04:42:12', '2023-05-10 04:44:58', NULL, 'healthy');

-- --------------------------------------------------------

--
-- Struktur dari tabel `designations`
--

CREATE TABLE `designations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `designations`
--

INSERT INTO `designations` (`id`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Team Leader', '2023-05-05 22:03:21', '2023-05-05 22:03:21', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `employees`
--

CREATE TABLE `employees` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `kode` varchar(255) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `schedule` varchar(255) DEFAULT NULL,
  `pleton` varchar(255) DEFAULT NULL,
  `designation_id` bigint(20) UNSIGNED DEFAULT NULL,
  `phone_number` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `employee_external_id` varchar(255) NOT NULL,
  `image` bigint(20) UNSIGNED DEFAULT NULL,
  `employee_input_order` int(11) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `ptkp_tax_list_id` bigint(20) UNSIGNED DEFAULT NULL,
  `employment_status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payroll_group_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_use_bpjsk` tinyint(1) NOT NULL DEFAULT 0,
  `bpjsk_number_card` varchar(255) DEFAULT NULL,
  `bpjsk_setting_id` bigint(20) UNSIGNED DEFAULT NULL,
  `bpjsk_specific_amount` decimal(48,4) DEFAULT NULL,
  `is_use_bpjstk` tinyint(1) NOT NULL DEFAULT 0,
  `bpjstk_number_card` varchar(255) DEFAULT NULL,
  `bpjstk_setting_id` bigint(20) UNSIGNED DEFAULT NULL,
  `bpjstk_old_age` tinyint(1) NOT NULL DEFAULT 0,
  `bpjstk_life_insurance` tinyint(1) NOT NULL DEFAULT 0,
  `bpjstk_pension_time` tinyint(1) NOT NULL DEFAULT 0,
  `bpjstk_specific_amount` decimal(48,4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `manager_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `employees`
--

INSERT INTO `employees` (`id`, `user_id`, `branch_id`, `kode`, `area`, `schedule`, `pleton`, `designation_id`, `phone_number`, `start_date`, `end_date`, `address`, `account_number`, `employee_external_id`, `image`, `employee_input_order`, `birth_date`, `gender`, `ptkp_tax_list_id`, `employment_status_id`, `payroll_group_id`, `is_use_bpjsk`, `bpjsk_number_card`, `bpjsk_setting_id`, `bpjsk_specific_amount`, `is_use_bpjstk`, `bpjstk_number_card`, `bpjstk_setting_id`, `bpjstk_old_age`, `bpjstk_life_insurance`, `bpjstk_pension_time`, `bpjstk_specific_amount`, `created_at`, `updated_at`, `deleted_at`, `account_name`, `bank_name`, `manager_id`) VALUES
(1, 3, 1, '', '', '', NULL, 1, '+6914296340', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050001', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(2, 4, 1, '', '', '', NULL, 1, '+901996280018', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050002', NULL, 2, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(3, 5, 1, '', '', '', NULL, 1, '+29084893', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050003', NULL, 3, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(4, 6, 1, '', '', '', NULL, 1, '+221027047317', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050004', NULL, 4, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(5, 7, 1, '', '', '', NULL, 1, '+377243940046', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050005', NULL, 5, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(6, 8, 1, '', '', '', NULL, 1, '+8802537075924', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050006', NULL, 6, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(7, 9, 1, '', '', '', NULL, 1, '+299167021', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050007', NULL, 7, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(8, 10, 1, '', '', '', NULL, 1, '+80093235579', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050008', NULL, 8, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(9, 11, 1, '', '', '', NULL, 1, '+243075033323', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050009', NULL, 9, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(10, 12, 1, '', '', '', NULL, 1, '+812301403823', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050010', NULL, 10, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(11, 13, 1, '', '', '', NULL, 1, '+6778064466', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050011', NULL, 11, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(12, 14, 1, '', '', '', NULL, 1, '+967906645561', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050012', NULL, 12, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(13, 15, 1, '', '', '', NULL, 1, '+298325946', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050013', NULL, 13, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(14, 16, 1, '', '', '', NULL, 1, '+244473312133', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050014', NULL, 14, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL, NULL, NULL),
(15, 17, 1, '', '', '', NULL, 1, '+88881778240943', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050015', NULL, 15, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL, NULL, NULL),
(16, 18, 1, '', '', '', NULL, 1, '+240043549481', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050016', NULL, 16, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL, NULL, NULL),
(17, 19, 1, '', '', '', NULL, 1, '+590265225416', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050017', NULL, 17, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL, NULL, NULL),
(18, 20, 1, '', '', '', NULL, 1, '+35769485230', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050018', NULL, 18, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL, NULL, NULL),
(19, 21, 1, '', '', '', NULL, 1, '+299235112', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050019', NULL, 19, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL, NULL, NULL),
(20, 22, 1, '', '', '', NULL, 1, '+264371840088', '2022-01-01', '2070-01-01', 'Jl Impian', '12412312312', '23050020', NULL, 20, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL, NULL, NULL),
(21, 23, 2, '', '', '', NULL, 1, '+6285156898315', '2023-05-07', NULL, 'sadsad', '3112133112', '23050021', 1, 21, NULL, NULL, 1, 1, 1, 0, NULL, NULL, '0.0000', 0, NULL, NULL, 0, 0, 0, '0.0000', '2023-05-06 19:57:52', '2023-05-06 19:57:52', NULL, 'sadasasd', 'bni', 1),
(22, 24, 5, '', '', '', NULL, 1, '+62832432423', '2023-05-01', NULL, 'asda', '1231212', 'sadas', 9, 22, NULL, NULL, 1, 1, 1, 0, NULL, NULL, '0.0000', 0, NULL, NULL, 0, 0, 0, '0.0000', '2023-05-12 19:48:32', '2023-05-12 19:48:32', NULL, 'sadas', 'bni', 2),
(32, 28, 8, '8,', 'Zamrud', 'Shift', 'Pleton 1', 1, '+6241223123123', '2023-05-13', NULL, 'asdas', '32231123', '1231231221331223213', 13, 23, NULL, NULL, 2, 1, 1, 0, NULL, NULL, '0.0000', 0, NULL, NULL, 0, 0, 0, '0.0000', '2023-05-12 23:36:13', '2023-05-13 00:32:54', NULL, 'sadasd', 'asdas', 1),
(33, 31, 8, '8,2', '', '', NULL, 1, '+622321312563', '2023-05-13', NULL, 'asdas', '321', '3426744', 16, 24, NULL, NULL, 2, 1, 1, 0, NULL, NULL, '0.0000', 0, NULL, NULL, 0, 0, 0, '0.0000', '2023-05-13 00:34:35', '2023-05-13 00:34:35', NULL, 'asd', 'asd', 1);

--
-- Trigger `employees`
--
DELIMITER $$
CREATE TRIGGER `increment_kode` BEFORE INSERT ON `employees` FOR EACH ROW BEGIN
            DECLARE branchid INT;
            DECLARE increment_number INT;
            SET branchid = NEW.branch_id;
            SET increment_number = (SELECT COUNT(*) FROM employees WHERE branch_id = NEW.branch_id);
            IF increment_number = 0 THEN
                SET NEW.kode = CONCAT(branchid, ',');
            ELSEIF increment_number > 10 THEN
                SET NEW.kode = CONCAT(branchid, ',', increment_number - 10);
            ELSE
                SET NEW.kode = CONCAT(branchid, ',', increment_number);
            END IF;
        END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `employee_groups`
--

CREATE TABLE `employee_groups` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `group_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `employee_resigns`
--

CREATE TABLE `employee_resigns` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `is_according_procedure` tinyint(1) NOT NULL DEFAULT 0,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `end_contract` date NOT NULL,
  `reason` text NOT NULL,
  `file` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `reject_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `employment_statuses`
--

CREATE TABLE `employment_statuses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `pkwt_type` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `employment_type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `employment_statuses`
--

INSERT INTO `employment_statuses` (`id`, `name`, `pkwt_type`, `status`, `employment_type`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Full Time', 'pkwtt', 1, 'pegawai tetap', '2023-05-05 22:03:21', '2023-05-05 22:03:21', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `files`
--

CREATE TABLE `files` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `url` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `extension` varchar(255) DEFAULT NULL,
  `size` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `path_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `files`
--

INSERT INTO `files` (`id`, `url`, `file_name`, `extension`, `size`, `created_at`, `updated_at`, `deleted_at`, `path_name`) VALUES
(1, '', '5b87lJQ0ZQbKY5O49jwg3EOeoITxrfQIFJzsvN1LvSRfvNodfp51YMBE3CkL', 'jpg', 51, '2023-05-06 19:57:52', '2023-05-06 19:57:52', NULL, '/storage/file/2023/05/07/5b87lJQ0ZQbKY5O49jwg3EOeoITxrfQIFJzsvN1LvSRfvNodfp51YMBE3CkL.jpg'),
(2, '', 'lRVKnVNB9MQgG3RxRLd0tCHPnknHC1wtuZhQ5GNMqbcAPQ2VC9mwsN6VV0Em', 'jpg', 29, '2023-05-06 19:58:40', '2023-05-06 19:58:40', NULL, '/storage/file/2023/05/07/lRVKnVNB9MQgG3RxRLd0tCHPnknHC1wtuZhQ5GNMqbcAPQ2VC9mwsN6VV0Em.jpg'),
(3, '', 'fMgtkJztzmZceSybKw3ssQY8mnuDrDlxIYIYSs6fNjP0vYA5ZrtkvUVBhICw', 'jpg', 27, '2023-05-06 20:00:09', '2023-05-06 20:00:09', NULL, '/storage/file/2023/05/07/fMgtkJztzmZceSybKw3ssQY8mnuDrDlxIYIYSs6fNjP0vYA5ZrtkvUVBhICw.jpg'),
(4, '', 'BOXFLdpgBvhR8UJZUOT1gMHS81kDZb0LSEMiaWGMRlJAE3JcBUsW2r2YJU8A', 'png', 167, '2023-05-10 04:42:59', '2023-05-10 04:42:59', NULL, '/storage/file/2023/05/10/BOXFLdpgBvhR8UJZUOT1gMHS81kDZb0LSEMiaWGMRlJAE3JcBUsW2r2YJU8A.png'),
(5, '', 'GqmKgErb7qfPDRsH7F5xWmPet3QStm8kZkYYbSTcGmtpNhr8lVJZNXoljeoU', 'png', 167, '2023-05-10 04:43:29', '2023-05-10 04:43:29', NULL, '/storage/file/2023/05/10/GqmKgErb7qfPDRsH7F5xWmPet3QStm8kZkYYbSTcGmtpNhr8lVJZNXoljeoU.png'),
(6, '', '3maLKxZ2moUJ0OG6dV8fOt1a2n8eSZIAdOgnIDMCJXWWi2aWDijQf5CWMqMJ', 'png', 34, '2023-05-10 04:43:58', '2023-05-10 04:43:58', NULL, '/storage/file/2023/05/10/3maLKxZ2moUJ0OG6dV8fOt1a2n8eSZIAdOgnIDMCJXWWi2aWDijQf5CWMqMJ.png'),
(7, '', 'IQZXXfuJSFQSg5kbjdDa9DtUJWjqxSiQvo4BE8twsUDLTQtsrxBHMA5LOgCd', 'png', 167, '2023-05-10 04:44:16', '2023-05-10 04:44:16', NULL, '/storage/file/2023/05/10/IQZXXfuJSFQSg5kbjdDa9DtUJWjqxSiQvo4BE8twsUDLTQtsrxBHMA5LOgCd.png'),
(8, '', 'mKmbot4cJBA41GG7BJJwqNhPCASjU1waIiUpMc2qjFunKRdaV6nr3U4I16hG', 'png', 167, '2023-05-10 04:44:58', '2023-05-10 04:44:58', NULL, '/storage/file/2023/05/10/mKmbot4cJBA41GG7BJJwqNhPCASjU1waIiUpMc2qjFunKRdaV6nr3U4I16hG.png'),
(9, '', 'YvpSimVdooTYkUmf13ikmGIamwWMaIBR1PUpPfHbpC6iaaeEUHfLn90HEpPc', 'png', 142, '2023-05-12 19:48:32', '2023-05-12 19:48:32', NULL, '/storage/file/2023/05/13/YvpSimVdooTYkUmf13ikmGIamwWMaIBR1PUpPfHbpC6iaaeEUHfLn90HEpPc.png'),
(10, '', 'TR8Tr6BrKinOrYQHAshihI56SrOW1uYor9kFBB4SnElmo97FknIBi5pI0kSq', 'jpg', 78, '2023-05-12 22:50:56', '2023-05-12 22:50:56', NULL, '/storage/file/2023/05/13/TR8Tr6BrKinOrYQHAshihI56SrOW1uYor9kFBB4SnElmo97FknIBi5pI0kSq.jpg'),
(11, '', '8BM3nrxrsxFiKXYBcCl2ByMJLZ3W0jcMTcPPwfV4SyRvXYabum4prcOAsVmH', 'png', 142, '2023-05-12 23:24:16', '2023-05-12 23:24:16', NULL, '/storage/file/2023/05/13/8BM3nrxrsxFiKXYBcCl2ByMJLZ3W0jcMTcPPwfV4SyRvXYabum4prcOAsVmH.png'),
(13, '', 'X4UsrWiXDJ9j74ve3SRajA5aqONOPjLdkbpdBvdPtaFAr1Ckis8lAsonJ84H', 'png', 197, '2023-05-12 23:36:13', '2023-05-12 23:36:13', NULL, '/storage/file/2023/05/13/X4UsrWiXDJ9j74ve3SRajA5aqONOPjLdkbpdBvdPtaFAr1Ckis8lAsonJ84H.png'),
(14, '', 'xOeSCmVmeNWv8eEZBcf406hqpUutoBhycJ8cH5c8jFEnjWIoFN3kX3hR7f7M', 'jpg', 9, '2023-05-12 23:39:27', '2023-05-12 23:39:27', NULL, '/storage/file/2023/05/13/xOeSCmVmeNWv8eEZBcf406hqpUutoBhycJ8cH5c8jFEnjWIoFN3kX3hR7f7M.jpg'),
(15, '', 'xhBtGxDTgIHXPPzKYelrWzYy3p6R1q4d7Rf9PvG9bCZ9X5CQvPOCqyQyhQyR', 'png', 12, '2023-05-13 00:01:25', '2023-05-13 00:01:25', NULL, '/storage/file/2023/05/13/xhBtGxDTgIHXPPzKYelrWzYy3p6R1q4d7Rf9PvG9bCZ9X5CQvPOCqyQyhQyR.png'),
(16, '', 'WgDMvvTIa0AOQE4cchml4pmTURMFStuHyQr1R55aUZY5losLeaobgEld1P47', 'jpg', 78, '2023-05-13 00:34:35', '2023-05-13 00:34:35', NULL, '/storage/file/2023/05/13/WgDMvvTIa0AOQE4cchml4pmTURMFStuHyQr1R55aUZY5losLeaobgEld1P47.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `groups`
--

CREATE TABLE `groups` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `holiday_calendars`
--

CREATE TABLE `holiday_calendars` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `leaves`
--

CREATE TABLE `leaves` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `leave_type_id` bigint(20) UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` text NOT NULL,
  `status` varchar(255) NOT NULL,
  `reject_reason` text DEFAULT NULL,
  `file` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `leave_quotas`
--

CREATE TABLE `leave_quotas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `leave_type_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `quota` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `leave_types`
--

CREATE TABLE `leave_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `quota` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(2, '2022_10_06_000001_create_users_table', 1),
(3, '2022_10_06_000002_create_password_resets_table', 1),
(4, '2022_10_06_000003_create_failed_jobs_table', 1),
(5, '2022_10_06_000005_create_permission_tables', 1),
(6, '2022_10_06_000006_create_modules_table', 1),
(7, '2022_10_06_000007_create_jobs_table', 1),
(8, '2022_10_06_000008_create_notifications_table', 1),
(9, '2022_10_06_000009_create_files_table', 1),
(10, '2022_10_06_000010_create_company_informations_table', 1),
(11, '2022_10_06_000011_create_employment_statuses_table', 1),
(12, '2022_10_06_000012_create_payroll_groups_table', 1),
(13, '2022_10_06_000013_create_npwp_lists_table', 1),
(14, '2022_10_06_000014_create_bpjsk_settings_table', 1),
(15, '2022_10_06_000015_create_bpjstk_risk_levels_table', 1),
(16, '2022_10_06_000016_create_bpjstk_settings_table', 1),
(17, '2022_10_06_000017_create_bpjstk_components_table', 1),
(18, '2022_10_06_000018_create_ptkp_tax_lists_table', 1),
(19, '2022_10_06_000019_create_branches_table', 1),
(20, '2022_10_06_000020_create_designations_table', 1),
(21, '2022_10_06_000021_create_employees_table', 1),
(22, '2022_10_06_000022_create_employee_resigns_table', 1),
(23, '2022_12_08_012433_change_logo_field_type_company_informations_table', 1),
(24, '2022_12_08_035625_add_path_name_field_to_files_table', 1),
(25, '2022_12_08_044926_add_status_field_to_company_informations_table', 1),
(26, '2022_12_10_071837_create_groups_table', 1),
(27, '2022_12_10_071840_create_employee_groups_table', 1),
(28, '2022_12_12_061234_update_field_bpjstk_settings_table', 1),
(29, '2022_12_13_025218_create_leave_types_table', 1),
(30, '2022_12_13_052347_create_leave_quotas_table', 1),
(31, '2022_12_13_053658_create_holiday_calendars_table', 1),
(32, '2022_12_13_091200_create_overtime_settings_table', 1),
(33, '2022_12_13_111118_create_overtime_rules_table', 1),
(34, '2022_12_14_013245_create_settings_table', 1),
(35, '2022_12_14_025803_create_payroll_employee_base_salaries_table', 1),
(36, '2022_12_15_013501_create_payroll_components_table', 1),
(37, '2022_12_15_014256_create_payroll_employee_components_table', 1),
(38, '2022_12_15_014717_create_payroll_branch_components_table', 1),
(39, '2022_12_15_080356_create_approval_types_table', 1),
(40, '2022_12_15_081015_create_approval_rules_table', 1),
(41, '2022_12_15_081045_create_approval_rule_levels_table', 1),
(42, '2022_12_19_015935_add_is_default_field_to_roles_table', 1),
(43, '2022_12_19_023232_add_several_field_to_permissions_table', 1),
(44, '2022_12_20_213706_create_shifts_table', 1),
(45, '2022_12_21_043314_change_nip_field_employees_table', 1),
(46, '2022_12_21_085705_change_end_date_fields_in_employees_table', 1),
(47, '2022_12_21_113958_add_finance_fields_to_employees_table', 1),
(48, '2022_12_23_025615_create_schedules_table', 1),
(49, '2022_12_23_032348_create_attendances_table', 1),
(50, '2022_12_23_033627_create_attendance_offline_logs_table', 1),
(51, '2022_12_23_034101_create_breaks_table', 1),
(52, '2022_12_23_034345_create_break_offline_attendances_table', 1),
(53, '2022_12_24_034002_create_leaves_table', 1),
(54, '2022_12_27_033821_add_reject_reason_field_to_employee_resigns_table', 1),
(55, '2022_12_27_044216_create_payroll_slips_table', 1),
(56, '2022_12_27_044542_create_payroll_employee_slips_table', 1),
(57, '2022_12_27_045109_create_payroll_slip_components_table', 1),
(58, '2022_12_27_090000_create_pph_range_rules_table', 1),
(59, '2022_12_27_131820_add_several_fields_to_payroll_employee_slips_table', 1),
(60, '2022_12_28_035423_add_end_date_fields_to_payroll_slips_table', 1),
(61, '2022_12_28_074534_create_notice_boards_table', 1),
(62, '2022_12_29_015145_add_manager_id_fields_to_employees_table', 1),
(63, '2022_12_29_020603_create_approvals_table', 1),
(64, '2022_12_29_020953_create_approval_steps_table', 1),
(65, '2022_12_29_102055_add_fcm_token_field_to_users_table', 1),
(66, '2023_01_12_082846_add_soft_delete_field_to_shifts_table', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 2),
(2, 'App\\Models\\User', 3),
(2, 'App\\Models\\User', 4),
(2, 'App\\Models\\User', 5),
(2, 'App\\Models\\User', 6),
(2, 'App\\Models\\User', 7),
(2, 'App\\Models\\User', 8),
(2, 'App\\Models\\User', 9),
(2, 'App\\Models\\User', 10),
(2, 'App\\Models\\User', 11),
(2, 'App\\Models\\User', 12),
(2, 'App\\Models\\User', 13),
(2, 'App\\Models\\User', 14),
(2, 'App\\Models\\User', 15),
(2, 'App\\Models\\User', 16),
(2, 'App\\Models\\User', 17),
(2, 'App\\Models\\User', 18),
(2, 'App\\Models\\User', 19),
(2, 'App\\Models\\User', 20),
(2, 'App\\Models\\User', 21),
(2, 'App\\Models\\User', 22),
(2, 'App\\Models\\User', 23),
(2, 'App\\Models\\User', 24),
(2, 'App\\Models\\User', 25),
(2, 'App\\Models\\User', 26),
(2, 'App\\Models\\User', 28),
(2, 'App\\Models\\User', 29),
(2, 'App\\Models\\User', 30),
(2, 'App\\Models\\User', 31);

-- --------------------------------------------------------

--
-- Struktur dari tabel `modules`
--

CREATE TABLE `modules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `module_name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'inActive',
  `version` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `modules`
--

INSERT INTO `modules` (`id`, `module_name`, `description`, `status`, `version`, `created_at`, `updated_at`) VALUES
(1, 'Employee', 'Module for manage employee', 'inActive', '1.0.0', '2023-05-05 22:03:21', '2023-05-05 22:03:21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `notice_boards`
--

CREATE TABLE `notice_boards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `start` timestamp NULL DEFAULT NULL,
  `end` timestamp NULL DEFAULT NULL,
  `file` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(255) NOT NULL,
  `notifiable_type` varchar(255) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `npwp_lists`
--

CREATE TABLE `npwp_lists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `npwp_name` varchar(255) NOT NULL,
  `npwp_company_name` varchar(255) NOT NULL,
  `number_npwp` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `kpp` varchar(255) DEFAULT NULL,
  `active_month` date NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `npwp_lists`
--

INSERT INTO `npwp_lists` (`id`, `npwp_name`, `npwp_company_name`, `number_npwp`, `address`, `postal_code`, `city`, `kpp`, `active_month`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Dummy', 'Dummy Corp', '244412321212', 'Jl Simpang Lima', '52212', 'Semarang', 'Dummy', '2023-05-06', 0, '2023-05-05 22:03:21', '2023-05-05 22:03:21', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `overtime_rules`
--

CREATE TABLE `overtime_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clock_in` time NOT NULL,
  `clock_out` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `overtime_settings`
--

CREATE TABLE `overtime_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `password_resets`
--

INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
('employee@beetlehr.com', '$2y$10$g/0B3jF1peiTPeFQoECiVupZv6hC0zfDrG9n/4qejyZwGtPYK0OEC', '2023-05-06 19:54:49');

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_branch_components`
--

CREATE TABLE `payroll_branch_components` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `component_id` bigint(20) UNSIGNED NOT NULL,
  `default_amount` decimal(48,4) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_components`
--

CREATE TABLE `payroll_components` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `is_mandatory` tinyint(1) NOT NULL DEFAULT 0,
  `is_editable` tinyint(1) NOT NULL DEFAULT 0,
  `is_taxable` tinyint(1) NOT NULL DEFAULT 0,
  `custom_attribute` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom_attribute`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `payroll_components`
--

INSERT INTO `payroll_components` (`id`, `name`, `type`, `is_mandatory`, `is_editable`, `is_taxable`, `custom_attribute`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Potongan Terlambat', 'deduction', 1, 0, 0, '{\"action\":\"deduction_late\"}', '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_employee_base_salaries`
--

CREATE TABLE `payroll_employee_base_salaries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(48,4) NOT NULL,
  `type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_employee_components`
--

CREATE TABLE `payroll_employee_components` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `component_id` bigint(20) UNSIGNED NOT NULL,
  `default_amount` decimal(48,4) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_employee_slips`
--

CREATE TABLE `payroll_employee_slips` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `payroll_slip_id` bigint(20) UNSIGNED NOT NULL,
  `payroll_employee_base_salary_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` decimal(48,4) DEFAULT NULL,
  `earning_total` decimal(48,4) DEFAULT NULL,
  `deduction_total` decimal(48,4) DEFAULT NULL,
  `total_amount` decimal(48,4) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `paid_on` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `bpjsk_value` decimal(48,4) DEFAULT NULL,
  `jkk` decimal(48,4) DEFAULT NULL,
  `jht` decimal(48,4) DEFAULT NULL,
  `jkm` decimal(48,4) DEFAULT NULL,
  `jp` decimal(48,4) DEFAULT NULL,
  `tax_value` decimal(48,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_groups`
--

CREATE TABLE `payroll_groups` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `payroll_groups`
--

INSERT INTO `payroll_groups` (`id`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Struktural', '2023-05-05 22:03:21', '2023-05-05 22:03:21', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_slips`
--

CREATE TABLE `payroll_slips` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `total_amount` decimal(48,4) DEFAULT NULL,
  `date` date NOT NULL,
  `is_all_branch` tinyint(1) NOT NULL DEFAULT 0,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_slip_components`
--

CREATE TABLE `payroll_slip_components` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payroll_employee_slip_id` bigint(20) UNSIGNED NOT NULL,
  `payroll_component_id` bigint(20) UNSIGNED NOT NULL,
  `value` decimal(48,4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `sub_group` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`, `label`, `group`, `sub_group`) VALUES
(1, 'view_general_dashboard', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Dashboard Overview', 'general', 'dashboard'),
(2, 'view_employee_management_employee', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Employee', 'employee_management', 'employee'),
(3, 'view_employee_management_resign_management', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Resign Management', 'employee_management', 'resign_management'),
(4, 'view_employee_management_attendance', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Attendance', 'employee_management', 'attendance'),
(5, 'view_employee_management_shift', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Shift', 'employee_management', 'shift'),
(6, 'view_employee_management_schedule', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Schedule', 'employee_management', 'schedule'),
(7, 'view_employee_management_leave', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Leave', 'employee_management', 'leave'),
(8, 'view_employee_management_approval', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Approval', 'employee_management', 'approval'),
(9, 'view_payroll_management_payroll', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Payroll', 'payroll_management', 'payroll'),
(10, 'view_notice_board_management', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Notive Board', 'notice_board_management', 'notice_board'),
(11, 'view_company_profile', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Profile', 'setting_company', 'profile'),
(12, 'view_company_npwp', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Npwp', 'setting_company', 'npwp'),
(13, 'view_company_branch', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Branch', 'setting_company', 'branch'),
(14, 'view_company_bpjs_kesehatan', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Bpjs Kesehatan', 'setting_company', 'bpjs_kesehatan'),
(15, 'view_company_bpjs_ketenagakerjaan', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Bpjs Ketenagakerjaan', 'setting_company', 'bpjs_ketenegakerjaan'),
(16, 'view_employee_general', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View General', 'setting_employee', 'general'),
(17, 'view_employee_designation', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Designation', 'setting_employee', 'designation'),
(18, 'view_employee_employment_status', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Employment Status', 'setting_employee', 'employment_status'),
(19, 'view_employee_group', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Group', 'setting_employee', 'group'),
(20, 'view_approval_rule', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Rule', 'setting_approval', 'rules'),
(21, 'view_leave_management_general', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Leave Management', 'setting_leave_management', 'general'),
(22, 'view_leave_management_leave_type', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Leave Type', 'setting_leave_management', 'leave_type'),
(23, 'view_leave_management_leave_quota', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Leave Quota', 'setting_leave_management', 'leave_quota'),
(24, 'view_attendance_general', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View General', 'setting_attendance', 'general'),
(25, 'view_attendance', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Attendance', 'setting_attendance', 'attendance'),
(26, 'view_attendance_holiday_calendar', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Holiday Calendar', 'setting_attendance', 'holiday_calendar'),
(27, 'view_payroll_general', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View General', 'setting_payroll', 'general'),
(28, 'view_payroll_group', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Payroll Group', 'setting_payroll', 'group'),
(29, 'view_payroll_employee_base_salaries', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Employee Base Salaries', 'setting_payroll', 'employee_base_salaries'),
(30, 'view_payroll_payroll_components', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Payroll Components', 'setting_payroll', 'payroll_components'),
(31, 'view_systems_authentication', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Authentication', 'setting_systems', 'authentication'),
(32, 'view_systems_role_management', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 'View Role Management', 'setting_systems', 'role_management');

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pleton`
--

CREATE TABLE `pleton` (
  `id` int(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `id_area` varchar(255) NOT NULL,
  `deleted_at` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pleton`
--

INSERT INTO `pleton` (`id`, `nama`, `id_area`, `deleted_at`) VALUES
(1, 'pleton 4', '1', NULL),
(2, 'asad', '2', NULL),
(3, 'sadas', '3', NULL),
(4, 'sadas', '4', NULL),
(5, 'sada', '5', NULL),
(6, 'asda', '1', NULL),
(7, 'asad', '6', NULL),
(8, 'pleton2', '1', NULL),
(9, 'asad', '1', NULL),
(10, 'Pleton 1', '7', NULL),
(11, 'Pleton 2', '7', NULL),
(12, 'Dinamic', '7', NULL),
(13, 'Emas', '7', NULL),
(14, 'asad', '7', NULL),
(15, 'test', '7', NULL),
(16, 'Pleton 1', '8', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pph_range_rules`
--

CREATE TABLE `pph_range_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `start_range` bigint(20) NOT NULL,
  `end_range` bigint(20) NOT NULL,
  `percentage` decimal(8,2) NOT NULL,
  `rate_layer` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pph_range_rules`
--

INSERT INTO `pph_range_rules` (`id`, `start_range`, `end_range`, `percentage`, `rate_layer`, `created_at`, `updated_at`) VALUES
(1, 0, 50000000, '5.00', 1, '2023-05-05 22:03:28', '2023-05-05 22:03:28'),
(2, 50000000, 250000000, '15.00', 2, '2023-05-05 22:03:28', '2023-05-05 22:03:28'),
(3, 250000000, 500000000, '25.00', 3, '2023-05-05 22:03:28', '2023-05-05 22:03:28'),
(4, 500000000, 5000000000, '30.00', 4, '2023-05-05 22:03:28', '2023-05-05 22:03:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `ptkp_tax_lists`
--

CREATE TABLE `ptkp_tax_lists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `ptkp_tax_lists`
--

INSERT INTO `ptkp_tax_lists` (`id`, `description`, `name`, `value`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Tidak Kawin Tanpa Tanggungan', 'TK/0', 54000000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(2, 'Tidak Kawin 1 Tanggungan', 'TK/1', 58500000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(3, 'Tidak Kawin 2 Tanggungan', 'TK/2', 63000000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(4, 'Tidak Kawin 3 Tanggungan', 'TK/3', 67500000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(5, 'Kawin Tanpa Tanggungan', 'K/0', 58500000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(6, 'Kawin 1 Tanggungan', 'K/1', 63000000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(7, 'Kawin 2 Tanggungan', 'K/2', 67500000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(8, 'Kawin 3 Tanggungan', 'K/3', 72000000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(9, 'Kawin Penghasilan Istri Digabung dengan Suami Tanpa Tanggungan', 'HB/0', 112500000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(10, 'Kawin Penghasilan Istri Digabung dengan Suami 1 Tanggungan', 'HB/1', 117000000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(11, 'Kawin Penghasilan Istri Digabung dengan Suami 2 Tanggungan', 'HB/2', 121500000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL),
(12, 'Kawin Penghasilan Istri Digabung dengan Suami 3 Tanggungan', 'HB/3', 126000000, '2023-05-05 22:03:13', '2023-05-05 22:03:13', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`, `is_default`) VALUES
(1, 'admin', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 1),
(2, 'employee', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 1),
(3, 'super admin', 'web', '2023-05-05 22:03:21', '2023-05-05 22:03:21', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 3),
(3, 1),
(3, 3),
(4, 1),
(4, 3),
(5, 1),
(5, 3),
(6, 1),
(6, 3),
(7, 1),
(7, 3),
(8, 1),
(8, 3),
(9, 1),
(9, 3),
(10, 1),
(10, 3),
(11, 1),
(11, 3),
(12, 1),
(12, 3),
(13, 1),
(13, 3),
(14, 1),
(14, 3),
(15, 1),
(15, 3),
(16, 1),
(16, 3),
(17, 1),
(17, 3),
(18, 1),
(18, 3),
(19, 1),
(19, 3),
(20, 1),
(20, 3),
(21, 1),
(21, 3),
(22, 1),
(22, 3),
(23, 1),
(23, 3),
(24, 1),
(24, 3),
(25, 1),
(25, 3),
(26, 1),
(26, 3),
(27, 1),
(27, 3),
(28, 1),
(28, 3),
(29, 1),
(29, 3),
(30, 1),
(30, 3),
(31, 1),
(31, 3),
(32, 1),
(32, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `schedules`
--

CREATE TABLE `schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `shift_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `date` date NOT NULL,
  `is_leave` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `schedules`
--

INSERT INTO `schedules` (`id`, `shift_id`, `user_id`, `date`, `is_leave`, `created_at`, `updated_at`) VALUES
(1, 1, 3, '2023-05-06', 0, '2023-05-06 08:47:26', '2023-05-06 08:47:26'),
(2, 1, 3, '2023-05-07', 0, '2023-05-06 08:47:26', '2023-05-06 08:47:26'),
(3, NULL, 24, '2023-05-01', 1, '2023-05-12 19:48:58', '2023-05-12 19:48:58'),
(4, NULL, 24, '2023-05-02', 1, '2023-05-12 19:48:58', '2023-05-12 19:48:58'),
(5, NULL, 24, '2023-05-03', 1, '2023-05-12 19:48:58', '2023-05-12 19:48:58'),
(6, NULL, 24, '2023-05-04', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(7, NULL, 24, '2023-05-05', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(8, NULL, 24, '2023-05-06', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(9, NULL, 24, '2023-05-07', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(10, NULL, 24, '2023-05-08', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(11, NULL, 24, '2023-05-09', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(12, NULL, 24, '2023-05-10', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(13, NULL, 24, '2023-05-11', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(14, NULL, 24, '2023-05-12', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(15, NULL, 24, '2023-05-13', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(16, NULL, 24, '2023-05-14', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(17, NULL, 24, '2023-05-15', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(18, NULL, 24, '2023-05-16', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(19, NULL, 24, '2023-05-17', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(20, NULL, 24, '2023-05-18', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(21, NULL, 24, '2023-05-19', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(22, NULL, 24, '2023-05-20', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(23, NULL, 24, '2023-05-21', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(24, NULL, 24, '2023-05-22', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(25, NULL, 24, '2023-05-23', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(26, NULL, 24, '2023-05-24', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(27, NULL, 24, '2023-05-25', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(28, NULL, 24, '2023-05-26', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(29, NULL, 24, '2023-05-27', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(30, NULL, 24, '2023-05-28', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(31, NULL, 24, '2023-05-29', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(32, NULL, 24, '2023-05-30', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59'),
(33, NULL, 24, '2023-05-31', 1, '2023-05-12 19:48:59', '2023-05-12 19:48:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'date_reset_leave_quota', '2023-01-01', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(2, 'close_break_page', '1', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(3, 'tolerance_notification', '15', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(4, 'tolerance_clock_in', '15', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(5, 'tolerance_clock_out', '18', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(6, 'is_absent_force_clock_out', '0', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(7, 'time_for_force_clockout_type', 'minutes', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(8, 'time_for_force_clockout_fixed', NULL, '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(9, 'time_for_force_clockout_minutes', '30', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(10, 'payroll_istaxable', '1', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(11, 'lock_user_device', '1', '2023-05-05 22:03:21', '2023-05-05 22:03:21'),
(12, 'editable_employee_external_id', '1', '2023-05-05 22:03:21', '2023-05-05 22:03:21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `shifts`
--

CREATE TABLE `shifts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `is_night_shift` tinyint(1) NOT NULL DEFAULT 0,
  `start_time` varchar(255) NOT NULL,
  `end_time` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `shifts`
--

INSERT INTO `shifts` (`id`, `branch_id`, `name`, `is_night_shift`, `start_time`, `end_time`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Shift Normal', 0, '08:00', '18:00', '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL),
(2, 1, 'Shift Malam', 1, '19:00', '02:00', '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL),
(3, 2, 'pppp', 0, '22:47', '22:47', '2023-05-06 08:47:51', '2023-05-06 08:47:51', NULL),
(4, 8, 'Shift', 0, '06:52', '12:52', '2023-05-12 22:52:51', '2023-05-12 22:52:51', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `struktur`
--

CREATE TABLE `struktur` (
  `id` int(255) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `pegawai_id` varchar(255) DEFAULT NULL,
  `jabatan_id` varchar(255) NOT NULL,
  `id_area` varchar(255) DEFAULT NULL,
  `schedule` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `struktur`
--

INSERT INTO `struktur` (`id`, `kode`, `pegawai_id`, `jabatan_id`, `id_area`, `schedule`) VALUES
(1, '5,', '1', '1', NULL, 'non shift\r\n'),
(2, '8,', '12', '1', NULL, 'non shift');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_device` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `fcm_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `user_device`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `deleted_at`, `fcm_token`) VALUES
(1, NULL, 'Admin', 'admin@beetlehr.com', NULL, '$2y$10$Q3tw0BoKTFZi02sZDqBy4O4Obbvk8TJm0fVL6t9QNsAVv4lCXcpau', NULL, '2023-05-05 22:03:21', '2023-05-05 22:03:21', NULL, NULL),
(2, NULL, 'employee', 'employee@beetlehr.com', NULL, '$2y$10$OqY5X/JAfKRF0T6AGdTADukeJpuoTI6wbb1tZ8GcGr9clRkbAqBli', NULL, '2023-05-05 22:03:21', '2023-05-05 22:03:21', NULL, NULL),
(3, NULL, 'Oliva Vanya Aryani S.E.', 'cpudjiastuti@example.com', '2023-05-05 22:03:27', '$2y$10$z1cZ6tSFjB.EWExg28Vb0.INmO4oGpUS3K0MTOmlVunOF7SlFQBIe', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(4, NULL, 'Ajeng Nuraini', 'paiman24@example.org', '2023-05-05 22:03:27', '$2y$10$jztKzw5jR7jTfKOg1vjjweNS1YccpY51Gq4cdOmXtPitAAF8CA8oS', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(5, NULL, 'Kasiran Cakrabuana Saputra', 'xdamanik@example.net', '2023-05-05 22:03:27', '$2y$10$h5n027QviNIkeiv2bURjkev7hczbFc6eKp10kJLB5XTGw8MW0ocIO', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(6, NULL, 'Anastasia Safitri', 'gawati.haryanto@example.com', '2023-05-05 22:03:27', '$2y$10$frS7ZQuKpBDyWIe.itbJnOT1guMvSguoPtGpNl3O5Q4S7bxwGNJ2W', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(7, NULL, 'Drajat Prasetya', 'saputra.septi@example.org', '2023-05-05 22:03:27', '$2y$10$K4ufh2HhQwytHyavZTYut.YWc/IgS/7.6bUMskSxGNkDltowwzTca', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(8, NULL, 'Jail Pranowo S.Sos', 'galang04@example.org', '2023-05-05 22:03:27', '$2y$10$hJDR5vmirRutvRQnsRHKdO7zEk67vUhuOeDvhHTlJ6IuHAnRfEXwi', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(9, NULL, 'Sabar Anggriawan', 'zelda.melani@example.net', '2023-05-05 22:03:27', '$2y$10$qI1To/bhYEtpSvn1e2P1mue/sdLuGxPjSc/fIhMECqZ2XNrivQU2.', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(10, NULL, 'Tira Pertiwi', 'samiah17@example.net', '2023-05-05 22:03:27', '$2y$10$d6mF5oU7Y/irWJpSSjQ9Gu/sY/mMz6dxpIqhs70aO1afeEfcVfCB.', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(11, NULL, 'Intan Zulaika', 'zulfa93@example.com', '2023-05-05 22:03:27', '$2y$10$ruZz8shDEqaGsTa4X6XsUuIUA6885J.sHSvhjEm87AjqmMUMuh0yi', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(12, NULL, 'Lulut Simbolon', 'zelaya.prastuti@example.net', '2023-05-05 22:03:27', '$2y$10$d/Dr9wNvN9PLBVAhk/WJV.QHoqCNxWwB6Ta5nltWOdzxEi/eVTZ7K', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(13, NULL, 'Rafid Mustofa', 'namaga.maryanto@example.org', '2023-05-05 22:03:27', '$2y$10$2/n6XJvKtjwteUgxuQbeLONE2f4IgrknOCjnScfwsjNfRW2gHqmEy', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(14, NULL, 'Marsito Hendri Sihotang', 'ihsan03@example.com', '2023-05-05 22:03:27', '$2y$10$VIu9Bk3Z3C70qyCzc950le2.c3Jp7gT0.70t8H.Jbs6zBMx4GkWPG', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(15, NULL, 'Laras Yuliarti', 'ina82@example.net', '2023-05-05 22:03:27', '$2y$10$qkuPUME4igxHdfnh5LzfvOUKAVLDz/W.aPWMybZByJs6laTLFtFKm', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(16, NULL, 'Cahyo Winarno', 'indra.narpati@example.net', '2023-05-05 22:03:27', '$2y$10$1cmJTY62sFXdawCQR3ouae5pUrUiPAmThJozuMUkqyBNhRFLa.mdW', NULL, '2023-05-05 22:03:27', '2023-05-05 22:03:27', NULL, NULL),
(17, NULL, 'Ulya Andriani', 'fathonah37@example.com', '2023-05-05 22:03:27', '$2y$10$0RMxAfv7ZHNzXlIvuV31T.MK.oMLa1JopJWPnAiGyvd7TDEK4Kz5y', NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL),
(18, NULL, 'Calista Uyainah', 'karimah05@example.com', '2023-05-05 22:03:28', '$2y$10$CjE1fOTdc3DEbrBTU8CoPeLoKy9sX27k8SVn581JGa7jTZ.Ta3Kpq', NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL),
(19, NULL, 'Emas Purwanto Utama', 'wastuti.maida@example.com', '2023-05-05 22:03:28', '$2y$10$x3SI6lUoE7B1KAECqGrV0O.UdDTn/knDqCzWXz/JSIuZ7uc5cyxL.', NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL),
(20, NULL, 'Kariman Kurniawan', 'sinaga.panca@example.org', '2023-05-05 22:03:28', '$2y$10$ms0baSqksiYB9Jma1z4yIOcRCpt2jnw4fwmMUeuyPavvPDPUetLGS', NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL),
(21, NULL, 'Hani Gabriella Yuniar S.Gz', 'lhandayani@example.com', '2023-05-05 22:03:28', '$2y$10$vNWPVby.PO7ndlb9CoAysOOzijlE0zdtlr2P6KLkpgJUdjFcIKcvG', NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL),
(22, NULL, 'Puti Mayasari', 'handayani.ibrahim@example.net', '2023-05-05 22:03:28', '$2y$10$icNktaqy4vxU/2pesSNmnemF8f8NygRVNBSdYM8urbCL0ZC4BM4qG', NULL, '2023-05-05 22:03:28', '2023-05-05 22:03:28', NULL, NULL),
(23, 'fd01ed9963d2692c', 'test', 'test@test.coom', NULL, '$2y$10$5tTgfdnNKRHHjiK8cL0aHOG06ENIqfgjlDxno0cs8D8U7OcrYaZxG', NULL, '2023-05-06 19:57:51', '2023-05-06 19:58:19', NULL, 'c_UvYZg9Tv6mBBTcQ8u_Xq:APA91bG3_NW5_NZ9kMV_Hwg8_U3K0rHpGH87rD-V7x9XbVQX3mSaHPPidOPNg9UNTeE3_l8fzOzSps3FX-4GOa31oOgV02osX9Y2gxtJe4LlyD-T0kC9_1qzWqYPQdWB8a0rXmzeu07n'),
(24, '11', 'Test', 'ronaldrobi00@gmail', NULL, '$2y$10$ozyUfPeaKEhIcTtFIZ2V9..BMyu7Cxbz1O12WwMEzJhAcBKobGeDC', NULL, '2023-05-12 19:48:32', '2023-05-12 19:48:32', NULL, NULL),
(25, '12', 'PegawaiBesar', 'besar@gmail.com', NULL, '$2y$10$pD9X8o16G5EK13g62p7OneNluXlqTHp/lCxGafjqcCBjKlCQxMRgW', NULL, '2023-05-12 22:50:56', '2023-05-12 22:50:56', NULL, NULL),
(26, 'gg', 'qq', 'as@gmail.com', NULL, '$2y$10$m3mZjGWsepHWUR4miBkHEufpK331itZT8owp3ZSr4nMna2/9NkqGa', NULL, '2023-05-12 23:24:15', '2023-05-12 23:24:15', NULL, NULL),
(28, 'asadassad', 'Aku Manager', 'aku@gmail.com', NULL, '$2y$10$wNu4CTUFhE698NsVML2neOJRo.5ofboE0ZAXjLgevRTp.v7OANkOu', NULL, '2023-05-12 23:36:13', '2023-05-13 00:32:54', NULL, NULL),
(29, 'sad', 'asdas', 'ooo@gmail.com', NULL, '$2y$10$0PFcRbidKvgs2tMbXmE6MucbGV5CcLOpmScmMbqDI9tLyLq15hxwq', NULL, '2023-05-12 23:39:27', '2023-05-12 23:39:27', NULL, NULL),
(30, 'sad', 'asdasd', 'sadas@gmail.com', NULL, '$2y$10$6uCXr2JIYW2I/M3hX1aEvuDF/2TZL7W6FmH/65e/Lf4hMV8xK2v8m', NULL, '2023-05-13 00:01:25', '2023-05-13 00:01:25', NULL, NULL),
(31, 'sadasd', 'sad', '321@gmail.com', NULL, '$2y$10$uU7OlfVi7ZjPfF1c2NkJBe5zH32ix3NsI7m8m5hjRgaNKhhxjIV.e', NULL, '2023-05-13 00:34:35', '2023-05-13 00:34:35', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `approvals`
--
ALTER TABLE `approvals`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `approval_rules`
--
ALTER TABLE `approval_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `approval_rules_branch_id_foreign` (`branch_id`),
  ADD KEY `approval_rules_approval_type_id_foreign` (`approval_type_id`);

--
-- Indeks untuk tabel `approval_rule_levels`
--
ALTER TABLE `approval_rule_levels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `approval_rule_levels_approval_rule_id_foreign` (`approval_rule_id`),
  ADD KEY `approval_rule_levels_employee_id_foreign` (`employee_id`);

--
-- Indeks untuk tabel `approval_steps`
--
ALTER TABLE `approval_steps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `approval_steps_approval_id_foreign` (`approval_id`);

--
-- Indeks untuk tabel `approval_types`
--
ALTER TABLE `approval_types`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `attendances`
--
ALTER TABLE `attendances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendances_user_id_foreign` (`user_id`),
  ADD KEY `attendances_clock_in_approved_by_foreign` (`clock_in_approved_by`),
  ADD KEY `attendances_clock_out_approved_by_foreign` (`clock_out_approved_by`);

--
-- Indeks untuk tabel `attendance_offline_logs`
--
ALTER TABLE `attendance_offline_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendance_offline_logs_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `bpjsk_settings`
--
ALTER TABLE `bpjsk_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `bpjstk_components`
--
ALTER TABLE `bpjstk_components`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `bpjstk_risk_levels`
--
ALTER TABLE `bpjstk_risk_levels`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `bpjstk_settings`
--
ALTER TABLE `bpjstk_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bpjstk_settings_bpjstk_risk_level_id_foreign` (`bpjstk_risk_level_id`);

--
-- Indeks untuk tabel `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `branches_npwp_list_id_foreign` (`npwp_list_id`);

--
-- Indeks untuk tabel `breaks`
--
ALTER TABLE `breaks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `breaks_attendance_id_foreign` (`attendance_id`);

--
-- Indeks untuk tabel `break_offline_attendances`
--
ALTER TABLE `break_offline_attendances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `break_offline_attendances_attendance_offline_log_id_foreign` (`attendance_offline_log_id`);

--
-- Indeks untuk tabel `company_informations`
--
ALTER TABLE `company_informations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `designations`
--
ALTER TABLE `designations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employees_phone_number_unique` (`phone_number`),
  ADD UNIQUE KEY `employees_nip_unique` (`employee_external_id`),
  ADD KEY `employees_user_id_foreign` (`user_id`),
  ADD KEY `employees_branch_id_foreign` (`branch_id`),
  ADD KEY `employees_designation_id_foreign` (`designation_id`),
  ADD KEY `employees_image_foreign` (`image`),
  ADD KEY `employees_ptkp_tax_list_id_foreign` (`ptkp_tax_list_id`),
  ADD KEY `employees_employment_status_id_foreign` (`employment_status_id`),
  ADD KEY `employees_payroll_group_id_foreign` (`payroll_group_id`),
  ADD KEY `employees_bpjsk_setting_id_foreign` (`bpjsk_setting_id`),
  ADD KEY `employees_bpjstk_setting_id_foreign` (`bpjstk_setting_id`);

--
-- Indeks untuk tabel `employee_groups`
--
ALTER TABLE `employee_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_groups_group_id_foreign` (`group_id`),
  ADD KEY `employee_groups_employee_id_foreign` (`employee_id`);

--
-- Indeks untuk tabel `employee_resigns`
--
ALTER TABLE `employee_resigns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_resigns_employee_id_foreign` (`employee_id`),
  ADD KEY `employee_resigns_file_foreign` (`file`);

--
-- Indeks untuk tabel `employment_statuses`
--
ALTER TABLE `employment_statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `holiday_calendars`
--
ALTER TABLE `holiday_calendars`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `leaves`
--
ALTER TABLE `leaves`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leaves_employee_id_foreign` (`employee_id`),
  ADD KEY `leaves_leave_type_id_foreign` (`leave_type_id`);

--
-- Indeks untuk tabel `leave_quotas`
--
ALTER TABLE `leave_quotas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leave_quotas_leave_type_id_foreign` (`leave_type_id`),
  ADD KEY `leave_quotas_employee_id_foreign` (`employee_id`);

--
-- Indeks untuk tabel `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leave_types_branch_id_foreign` (`branch_id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indeks untuk tabel `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indeks untuk tabel `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `notice_boards`
--
ALTER TABLE `notice_boards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notice_boards_branch_id_foreign` (`branch_id`);

--
-- Indeks untuk tabel `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indeks untuk tabel `npwp_lists`
--
ALTER TABLE `npwp_lists`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `overtime_rules`
--
ALTER TABLE `overtime_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `overtime_settings`
--
ALTER TABLE `overtime_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indeks untuk tabel `payroll_branch_components`
--
ALTER TABLE `payroll_branch_components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_branch_components_branch_id_foreign` (`branch_id`),
  ADD KEY `payroll_branch_components_component_id_foreign` (`component_id`);

--
-- Indeks untuk tabel `payroll_components`
--
ALTER TABLE `payroll_components`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `payroll_employee_base_salaries`
--
ALTER TABLE `payroll_employee_base_salaries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_employee_base_salaries_employee_id_foreign` (`employee_id`);

--
-- Indeks untuk tabel `payroll_employee_components`
--
ALTER TABLE `payroll_employee_components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_employee_components_employee_id_foreign` (`employee_id`),
  ADD KEY `payroll_employee_components_component_id_foreign` (`component_id`);

--
-- Indeks untuk tabel `payroll_employee_slips`
--
ALTER TABLE `payroll_employee_slips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_employee_slips_employee_id_foreign` (`employee_id`),
  ADD KEY `payroll_employee_slips_payroll_slip_id_foreign` (`payroll_slip_id`),
  ADD KEY `payroll_employee_slips_payroll_employee_base_salary_id_foreign` (`payroll_employee_base_salary_id`);

--
-- Indeks untuk tabel `payroll_groups`
--
ALTER TABLE `payroll_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `payroll_slips`
--
ALTER TABLE `payroll_slips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_slips_branch_id_foreign` (`branch_id`),
  ADD KEY `payroll_slips_created_by_foreign` (`created_by`);

--
-- Indeks untuk tabel `payroll_slip_components`
--
ALTER TABLE `payroll_slip_components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_slip_components_payroll_employee_slip_id_foreign` (`payroll_employee_slip_id`),
  ADD KEY `payroll_slip_components_payroll_component_id_foreign` (`payroll_component_id`);

--
-- Indeks untuk tabel `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indeks untuk tabel `pleton`
--
ALTER TABLE `pleton`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pph_range_rules`
--
ALTER TABLE `pph_range_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `ptkp_tax_lists`
--
ALTER TABLE `ptkp_tax_lists`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indeks untuk tabel `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indeks untuk tabel `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `schedules_shift_id_foreign` (`shift_id`),
  ADD KEY `schedules_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_key_unique` (`key`);

--
-- Indeks untuk tabel `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shifts_branch_id_foreign` (`branch_id`);

--
-- Indeks untuk tabel `struktur`
--
ALTER TABLE `struktur`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `approvals`
--
ALTER TABLE `approvals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `approval_rules`
--
ALTER TABLE `approval_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `approval_rule_levels`
--
ALTER TABLE `approval_rule_levels`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `approval_steps`
--
ALTER TABLE `approval_steps`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `approval_types`
--
ALTER TABLE `approval_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `area`
--
ALTER TABLE `area`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `attendances`
--
ALTER TABLE `attendances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `attendance_offline_logs`
--
ALTER TABLE `attendance_offline_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `bpjsk_settings`
--
ALTER TABLE `bpjsk_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `bpjstk_components`
--
ALTER TABLE `bpjstk_components`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `bpjstk_risk_levels`
--
ALTER TABLE `bpjstk_risk_levels`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `bpjstk_settings`
--
ALTER TABLE `bpjstk_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `branches`
--
ALTER TABLE `branches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `breaks`
--
ALTER TABLE `breaks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `break_offline_attendances`
--
ALTER TABLE `break_offline_attendances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `company_informations`
--
ALTER TABLE `company_informations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `designations`
--
ALTER TABLE `designations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `employees`
--
ALTER TABLE `employees`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `employee_groups`
--
ALTER TABLE `employee_groups`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `employee_resigns`
--
ALTER TABLE `employee_resigns`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `employment_statuses`
--
ALTER TABLE `employment_statuses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `files`
--
ALTER TABLE `files`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `groups`
--
ALTER TABLE `groups`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `holiday_calendars`
--
ALTER TABLE `holiday_calendars`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `leaves`
--
ALTER TABLE `leaves`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `leave_quotas`
--
ALTER TABLE `leave_quotas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT untuk tabel `modules`
--
ALTER TABLE `modules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `notice_boards`
--
ALTER TABLE `notice_boards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `npwp_lists`
--
ALTER TABLE `npwp_lists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `overtime_rules`
--
ALTER TABLE `overtime_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `overtime_settings`
--
ALTER TABLE `overtime_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_branch_components`
--
ALTER TABLE `payroll_branch_components`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_components`
--
ALTER TABLE `payroll_components`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `payroll_employee_base_salaries`
--
ALTER TABLE `payroll_employee_base_salaries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_employee_components`
--
ALTER TABLE `payroll_employee_components`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_employee_slips`
--
ALTER TABLE `payroll_employee_slips`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_groups`
--
ALTER TABLE `payroll_groups`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `payroll_slips`
--
ALTER TABLE `payroll_slips`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_slip_components`
--
ALTER TABLE `payroll_slip_components`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pleton`
--
ALTER TABLE `pleton`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `pph_range_rules`
--
ALTER TABLE `pph_range_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `ptkp_tax_lists`
--
ALTER TABLE `ptkp_tax_lists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `schedules`
--
ALTER TABLE `schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `struktur`
--
ALTER TABLE `struktur`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `approval_rules`
--
ALTER TABLE `approval_rules`
  ADD CONSTRAINT `approval_rules_approval_type_id_foreign` FOREIGN KEY (`approval_type_id`) REFERENCES `approval_types` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `approval_rules_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `approval_rule_levels`
--
ALTER TABLE `approval_rule_levels`
  ADD CONSTRAINT `approval_rule_levels_approval_rule_id_foreign` FOREIGN KEY (`approval_rule_id`) REFERENCES `approval_rules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `approval_rule_levels_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `approval_steps`
--
ALTER TABLE `approval_steps`
  ADD CONSTRAINT `approval_steps_approval_id_foreign` FOREIGN KEY (`approval_id`) REFERENCES `approvals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `attendances`
--
ALTER TABLE `attendances`
  ADD CONSTRAINT `attendances_clock_in_approved_by_foreign` FOREIGN KEY (`clock_in_approved_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `attendances_clock_out_approved_by_foreign` FOREIGN KEY (`clock_out_approved_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `attendances_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `attendance_offline_logs`
--
ALTER TABLE `attendance_offline_logs`
  ADD CONSTRAINT `attendance_offline_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `bpjstk_settings`
--
ALTER TABLE `bpjstk_settings`
  ADD CONSTRAINT `bpjstk_settings_bpjstk_risk_level_id_foreign` FOREIGN KEY (`bpjstk_risk_level_id`) REFERENCES `bpjstk_risk_levels` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `branches`
--
ALTER TABLE `branches`
  ADD CONSTRAINT `branches_npwp_list_id_foreign` FOREIGN KEY (`npwp_list_id`) REFERENCES `npwp_lists` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `breaks`
--
ALTER TABLE `breaks`
  ADD CONSTRAINT `breaks_attendance_id_foreign` FOREIGN KEY (`attendance_id`) REFERENCES `attendances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `break_offline_attendances`
--
ALTER TABLE `break_offline_attendances`
  ADD CONSTRAINT `break_offline_attendances_attendance_offline_log_id_foreign` FOREIGN KEY (`attendance_offline_log_id`) REFERENCES `attendance_offline_logs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_bpjsk_setting_id_foreign` FOREIGN KEY (`bpjsk_setting_id`) REFERENCES `bpjsk_settings` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_bpjstk_setting_id_foreign` FOREIGN KEY (`bpjstk_setting_id`) REFERENCES `bpjstk_settings` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_designation_id_foreign` FOREIGN KEY (`designation_id`) REFERENCES `designations` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_employment_status_id_foreign` FOREIGN KEY (`employment_status_id`) REFERENCES `employment_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_image_foreign` FOREIGN KEY (`image`) REFERENCES `files` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_payroll_group_id_foreign` FOREIGN KEY (`payroll_group_id`) REFERENCES `payroll_groups` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_ptkp_tax_list_id_foreign` FOREIGN KEY (`ptkp_tax_list_id`) REFERENCES `ptkp_tax_lists` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `employee_groups`
--
ALTER TABLE `employee_groups`
  ADD CONSTRAINT `employee_groups_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employee_groups_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `employee_resigns`
--
ALTER TABLE `employee_resigns`
  ADD CONSTRAINT `employee_resigns_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `employee_resigns_file_foreign` FOREIGN KEY (`file`) REFERENCES `files` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `leaves`
--
ALTER TABLE `leaves`
  ADD CONSTRAINT `leaves_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `leaves_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `leave_quotas`
--
ALTER TABLE `leave_quotas`
  ADD CONSTRAINT `leave_quotas_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `leave_quotas_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `leave_types`
--
ALTER TABLE `leave_types`
  ADD CONSTRAINT `leave_types_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `notice_boards`
--
ALTER TABLE `notice_boards`
  ADD CONSTRAINT `notice_boards_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_branch_components`
--
ALTER TABLE `payroll_branch_components`
  ADD CONSTRAINT `payroll_branch_components_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payroll_branch_components_component_id_foreign` FOREIGN KEY (`component_id`) REFERENCES `payroll_components` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_employee_base_salaries`
--
ALTER TABLE `payroll_employee_base_salaries`
  ADD CONSTRAINT `payroll_employee_base_salaries_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_employee_components`
--
ALTER TABLE `payroll_employee_components`
  ADD CONSTRAINT `payroll_employee_components_component_id_foreign` FOREIGN KEY (`component_id`) REFERENCES `payroll_components` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payroll_employee_components_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_employee_slips`
--
ALTER TABLE `payroll_employee_slips`
  ADD CONSTRAINT `payroll_employee_slips_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payroll_employee_slips_payroll_employee_base_salary_id_foreign` FOREIGN KEY (`payroll_employee_base_salary_id`) REFERENCES `payroll_employee_base_salaries` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payroll_employee_slips_payroll_slip_id_foreign` FOREIGN KEY (`payroll_slip_id`) REFERENCES `payroll_slips` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_slips`
--
ALTER TABLE `payroll_slips`
  ADD CONSTRAINT `payroll_slips_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payroll_slips_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_slip_components`
--
ALTER TABLE `payroll_slip_components`
  ADD CONSTRAINT `payroll_slip_components_payroll_component_id_foreign` FOREIGN KEY (`payroll_component_id`) REFERENCES `payroll_components` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payroll_slip_components_payroll_employee_slip_id_foreign` FOREIGN KEY (`payroll_employee_slip_id`) REFERENCES `payroll_employee_slips` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_shift_id_foreign` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `schedules_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `shifts_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
