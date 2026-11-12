-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 12 nov. 2026 à 16:11
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `bd_stock_multitenant`
--

-- --------------------------------------------------------

--
-- Structure de la table `achats`
--

CREATE TABLE `achats` (
  `achat_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `fournisseur_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `purchase_no` varchar(50) NOT NULL,
  `purchase_date` datetime DEFAULT current_timestamp(),
  `validation_date` datetime DEFAULT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(15,2) NOT NULL DEFAULT 0.00,
  `monais` varchar(10) DEFAULT NULL,
  `movement_type` enum('IN','OUT') NOT NULL DEFAULT 'IN',
  `motif_sortie` varchar(255) DEFAULT NULL,
  `status` enum('PENDING','RECEIVED','CANCELLED') NOT NULL DEFAULT 'RECEIVED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `achats`
--

INSERT INTO `achats` (`achat_id`, `entreprise_id`, `succursale_id`, `fournisseur_id`, `user_id`, `purchase_no`, `purchase_date`, `validation_date`, `total_amount`, `amount_paid`, `monais`, `movement_type`, `motif_sortie`, `status`, `created_at`) VALUES
(53, 9, 8, 8, 13, 'Zadd', '2026-10-09 16:57:59', '2026-10-09 16:57:59', 20000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-10-09 14:57:59'),
(54, 9, 8, 8, 13, 'R5g', '2026-10-09 17:02:36', '2026-10-09 17:02:36', 150000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-10-09 15:02:36'),
(55, 9, 8, NULL, 13, 'F', '2026-10-09 17:08:35', '2026-10-09 17:08:35', 0.00, 0.00, NULL, 'OUT', 'Expiration', 'RECEIVED', '2026-10-09 15:08:35'),
(64, 12, 12, 10, 19, '1egy', '2026-10-12 17:38:05', '2026-10-12 17:38:05', 100.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-12 15:38:05'),
(71, 13, 13, NULL, 20, 'Atg', '2026-11-03 09:32:53', '2026-11-03 09:32:53', 1000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-03 08:32:53'),
(72, 13, 14, NULL, 22, '1', '2026-11-04 18:33:25', '2026-11-04 18:33:25', 30000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-04 17:33:25'),
(73, 13, 14, NULL, 22, 'Th', '2026-11-04 18:33:55', '2026-11-04 18:35:04', 36000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-04 17:33:55'),
(74, 13, 14, NULL, 22, 'Gj', '2026-11-04 18:34:26', '2026-11-04 18:34:26', 30000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-04 17:34:26'),
(75, 13, 14, NULL, 22, 'Y', '2026-11-04 18:34:51', '2026-11-04 18:34:51', 6000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-04 17:34:51'),
(76, 13, 14, NULL, 22, 'PREV-20261104-6-001', '2026-11-04 18:41:59', '2026-11-04 18:43:49', 9000.00, 0.00, 'CDF', 'IN', NULL, 'RECEIVED', '2026-11-04 17:41:59'),
(77, 13, 14, NULL, 22, 'PREV-20261104-6-002', '2026-11-04 18:41:59', '2026-11-04 18:43:41', 5700.00, 0.00, 'CDF', 'IN', NULL, 'RECEIVED', '2026-11-04 17:41:59'),
(78, 13, 14, NULL, 22, 'PREV-20261104-5-001', '2026-11-04 18:42:04', '2026-11-04 18:43:27', 9000.00, 0.00, 'CDF', 'IN', NULL, 'RECEIVED', '2026-11-04 17:42:04'),
(79, 13, 14, NULL, 22, 'PREV-20261104-5-002', '2026-11-04 18:42:04', '2026-11-04 18:43:14', 5700.00, 0.00, 'CDF', 'IN', NULL, 'RECEIVED', '2026-11-04 17:42:04'),
(80, 13, 14, NULL, 22, 'Fc', '2026-11-04 18:46:54', '2026-11-04 18:46:54', 300.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-04 17:46:54'),
(81, 13, 14, NULL, 22, 'Fca', '2026-11-04 18:47:27', '2026-11-04 18:47:27', 372.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-04 17:47:27'),
(82, 13, 13, NULL, 20, 'Fy', '2026-11-05 15:23:32', '2026-11-05 15:23:32', 10000.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 14:23:32'),
(83, 16, 17, NULL, 27, 'Tj', '2026-11-05 17:27:56', '2026-11-05 17:27:56', 15000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-05 16:27:56'),
(84, 16, 17, NULL, 27, 'Eg', '2026-11-05 17:28:28', '2026-11-05 17:28:28', 6000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-05 16:28:28'),
(85, 16, 17, NULL, 27, 'U', '2026-11-05 17:30:15', '2026-11-05 17:30:15', 9000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-05 16:30:15'),
(86, 16, 17, NULL, 27, '13', '2026-11-05 17:31:17', '2026-11-05 17:31:17', 6000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-05 16:31:17'),
(87, 16, 17, NULL, 27, '1', '2026-11-05 17:41:02', '2026-11-05 17:41:02', 30.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 16:41:02'),
(88, 16, 17, NULL, 27, '2', '2026-11-05 17:41:43', '2026-11-05 17:41:43', 7.50, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 16:41:43'),
(89, 16, 17, NULL, 27, 'R', '2026-11-05 17:46:06', '2026-11-05 17:46:06', 30.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 16:46:06'),
(90, 16, 17, NULL, 27, 'Gj', '2026-11-05 17:46:23', '2026-11-05 17:46:23', 15.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 16:46:23'),
(91, 16, 17, NULL, 27, 'Tg', '2026-11-05 17:46:48', '2026-11-05 17:46:48', 7.50, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 16:46:48'),
(94, 16, 17, NULL, 27, 'Gjj', '2026-11-05 17:51:58', '2026-11-05 17:51:58', 45.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 16:51:58'),
(95, 16, 17, NULL, 27, 'Fv', '2026-11-05 18:07:20', '2026-11-05 18:07:20', 2500.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 17:07:20'),
(96, 16, 17, NULL, 27, 'Gjh', '2026-11-05 18:08:02', '2026-11-05 18:08:02', 3500.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-05 17:08:02'),
(97, 16, 17, NULL, 27, 'Ukkb', '2026-11-05 18:11:02', '2026-11-05 18:11:02', 400.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-11-05 17:11:02'),
(98, 18, 19, NULL, 29, 'Rsyd', '2026-11-09 20:41:30', '2026-11-09 20:41:30', 24.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-09 19:41:30'),
(99, 18, 19, NULL, 29, 'Du', '2026-11-09 20:42:53', '2026-11-09 20:42:53', 140.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-11-09 19:42:53');

-- --------------------------------------------------------

--
-- Structure de la table `achat_details`
--

CREATE TABLE `achat_details` (
  `achat_detail_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `achat_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `date_expiration` date DEFAULT NULL,
  `quantity_out` decimal(15,3) NOT NULL DEFAULT 0.000,
  `unit_cost` decimal(15,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `achat_details`
--

INSERT INTO `achat_details` (`achat_detail_id`, `entreprise_id`, `achat_id`, `produit_id`, `quantity`, `date_expiration`, `quantity_out`, `unit_cost`, `subtotal`, `created_at`) VALUES
(32, 9, 53, 13, 20.000, '2026-10-12', 8.000, 1000.00, 20000.00, '2026-10-09 14:57:59'),
(33, 9, 54, 12, 50.000, NULL, 0.000, 3000.00, 150000.00, '2026-10-09 15:02:36'),
(34, 9, 55, 13, 5.000, NULL, 0.000, 0.00, 0.00, '2026-10-09 15:08:35'),
(43, 12, 64, 19, 10.000, '2026-10-15', 5.000, 10.00, 100.00, '2026-10-12 15:38:05'),
(50, 13, 71, 25, 10.000, '2026-11-07', 2.000, 100.00, 1000.00, '2026-11-03 08:32:56'),
(51, 13, 72, 27, 50.000, '2026-11-29', 0.000, 600.00, 30000.00, '2026-11-04 17:33:25'),
(52, 13, 73, 27, 60.000, '2026-11-21', 52.000, 600.00, 36000.00, '2026-11-04 17:33:55'),
(53, 13, 74, 26, 100.000, '2026-12-31', 0.000, 300.00, 30000.00, '2026-11-04 17:34:26'),
(54, 13, 75, 26, 20.000, '2026-11-28', 10.000, 300.00, 6000.00, '2026-11-04 17:34:51'),
(55, 13, 76, 27, 15.000, '2026-11-22', 0.000, 600.00, 9000.00, '2026-11-04 17:41:59'),
(56, 13, 77, 26, 19.000, '2026-11-13', 0.000, 300.00, 5700.00, '2026-11-04 17:41:59'),
(57, 13, 78, 27, 15.000, '2026-11-20', 0.000, 600.00, 9000.00, '2026-11-04 17:42:04'),
(58, 13, 79, 26, 19.000, '2026-11-29', 0.000, 300.00, 5700.00, '2026-11-04 17:42:04'),
(59, 13, 80, 28, 5.000, NULL, 0.000, 60.00, 300.00, '2026-11-04 17:46:54'),
(60, 13, 81, 28, 6.000, NULL, 0.000, 62.00, 372.00, '2026-11-04 17:47:27'),
(61, 13, 82, 29, 10.000, NULL, 0.000, 1000.00, 10000.00, '2026-11-05 14:23:32'),
(62, 16, 83, 30, 50.000, '2026-12-31', 0.000, 300.00, 15000.00, '2026-11-05 16:27:56'),
(63, 16, 84, 30, 20.000, '2026-12-27', 0.000, 300.00, 6000.00, '2026-11-05 16:28:28'),
(64, 16, 85, 30, 30.000, '2026-11-22', 0.000, 300.00, 9000.00, '2026-11-05 16:30:15'),
(65, 16, 86, 30, 20.000, '2026-11-14', 15.500, 300.00, 6000.00, '2026-11-05 16:31:17'),
(66, 16, 87, 31, 20.000, NULL, 0.000, 1.50, 30.00, '2026-11-05 16:41:02'),
(67, 16, 88, 31, 5.000, NULL, 0.000, 1.50, 7.50, '2026-11-05 16:41:43'),
(68, 16, 89, 32, 20.000, '2026-11-30', 9.000, 1.50, 30.00, '2026-11-05 16:46:06'),
(69, 16, 90, 32, 10.000, '2026-11-30', 0.000, 1.50, 15.00, '2026-11-05 16:46:24'),
(70, 16, 91, 32, 5.000, '2026-12-03', 0.000, 1.50, 7.50, '2026-11-05 16:46:50'),
(71, 16, 94, 31, 30.000, NULL, 0.000, 1.50, 45.00, '2026-11-05 16:51:58'),
(72, 16, 95, 32, 10.000, '2026-11-28', 0.000, 250.00, 2500.00, '2026-11-05 17:07:21'),
(73, 16, 96, 32, 10.000, '2026-11-27', 0.000, 350.00, 3500.00, '2026-11-05 17:08:03'),
(74, 16, 97, 30, 2.000, '2026-11-22', 0.000, 200.00, 400.00, '2026-11-05 17:11:02'),
(75, 18, 98, 33, 12.000, NULL, 0.000, 2.00, 24.00, '2026-11-09 19:41:33'),
(76, 18, 99, 34, 10.000, NULL, 0.000, 14.00, 140.00, '2026-11-09 19:42:54');

-- --------------------------------------------------------

--
-- Structure de la table `achat_detail_sorties`
--

CREATE TABLE `achat_detail_sorties` (
  `sortie_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `sortie_detail_id` int(11) NOT NULL,
  `lot_detail_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `achat_detail_sorties`
--

INSERT INTO `achat_detail_sorties` (`sortie_id`, `entreprise_id`, `sortie_detail_id`, `lot_detail_id`, `quantity`, `created_at`) VALUES
(6, 9, 34, 32, 5.000, '2026-10-09 15:08:35');

-- --------------------------------------------------------

--
-- Structure de la table `banques`
--

CREATE TABLE `banques` (
  `banque_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `account_number` varchar(80) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `banques`
--

INSERT INTO `banques` (`banque_id`, `entreprise_id`, `name`, `account_number`, `is_active`, `created_at`) VALUES
(3, 13, 'COOPEC', NULL, 1, '2026-10-23 20:31:32');

-- --------------------------------------------------------

--
-- Structure de la table `bons_commande_previsionnels`
--

CREATE TABLE `bons_commande_previsionnels` (
  `bon_previsionnel_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `status` enum('DRAFT','TRANSMITTED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `transmitted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `bons_commande_previsionnels`
--

INSERT INTO `bons_commande_previsionnels` (`bon_previsionnel_id`, `entreprise_id`, `succursale_id`, `user_id`, `reference`, `status`, `created_at`, `transmitted_at`) VALUES
(5, 13, 14, 22, 'PREV-20261104-5', 'TRANSMITTED', '2026-11-04 17:41:07', '2026-11-04 18:42:04'),
(6, 13, 14, 22, 'PREV-20261104-6', 'TRANSMITTED', '2026-11-04 17:41:54', '2026-11-04 18:41:59'),
(7, 13, 14, 22, 'PREV-20261104-7', 'DRAFT', '2026-11-04 17:52:28', NULL),
(8, 13, 14, 22, 'PREV-20261104-8', 'DRAFT', '2026-11-04 17:52:34', NULL),
(10, 13, 14, 20, 'PREV-20261105-10', 'DRAFT', '2026-11-05 13:54:51', NULL),
(11, 13, 13, 20, 'PREV-20261105-11', 'DRAFT', '2026-11-05 14:47:49', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `bon_commande_previsionnel_details`
--

CREATE TABLE `bon_commande_previsionnel_details` (
  `detail_previsionnel_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `bon_previsionnel_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `fournisseur_id` int(11) DEFAULT NULL,
  `stock_disponible` decimal(15,3) NOT NULL,
  `mad` decimal(15,4) NOT NULL DEFAULT 0.0000,
  `cmm` decimal(15,4) NOT NULL DEFAULT 0.0000,
  `quantite_recommandee` decimal(15,3) NOT NULL,
  `quantite_commande` decimal(15,3) NOT NULL,
  `unit_cost` decimal(15,2) NOT NULL DEFAULT 0.00,
  `monais` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `bon_commande_previsionnel_details`
--

INSERT INTO `bon_commande_previsionnel_details` (`detail_previsionnel_id`, `entreprise_id`, `bon_previsionnel_id`, `produit_id`, `fournisseur_id`, `stock_disponible`, `mad`, `cmm`, `quantite_recommandee`, `quantite_commande`, `unit_cost`, `monais`, `created_at`) VALUES
(5, 13, 5, 27, NULL, 58.000, 52.0000, 1582.7500, 1502.000, 1502.000, 600.00, 'CDF', '2026-11-04 17:41:08'),
(6, 13, 5, 26, NULL, 110.000, 10.0000, 304.3800, 190.000, 190.000, 300.00, 'CDF', '2026-11-04 17:41:08'),
(7, 13, 6, 27, NULL, 58.000, 52.0000, 1582.7500, 1502.000, 15.000, 600.00, 'CDF', '2026-11-04 17:41:54'),
(8, 13, 6, 26, NULL, 110.000, 10.0000, 304.3800, 190.000, 19.000, 300.00, 'CDF', '2026-11-04 17:41:54'),
(9, 13, 7, 28, NULL, 8.000, 3.0000, 91.3100, 82.000, 82.000, 0.00, 'USD', '2026-11-04 17:52:28'),
(10, 13, 8, 28, NULL, 8.000, 3.0000, 91.3100, 82.000, 82.000, 0.00, 'USD', '2026-11-04 17:52:36'),
(13, 13, 10, 27, NULL, 88.000, 52.0000, 1582.7500, 1472.000, 276.000, 600.00, 'CDF', '2026-11-05 13:54:51'),
(14, 13, 10, 28, NULL, 8.000, 3.0000, 91.3100, 82.000, 13.000, 0.00, 'USD', '2026-11-05 13:54:51'),
(16, 13, 11, 25, NULL, 8.000, 1.0000, 30.4400, 22.000, 53.000, 0.00, 'CDF', '2026-11-05 14:47:57');

-- --------------------------------------------------------

--
-- Structure de la table `caisses`
--

CREATE TABLE `caisses` (
  `caisse_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `type_caisse_id` int(11) NOT NULL,
  `mode_paiement_id` int(11) NOT NULL,
  `banque_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL COMMENT 'Caissier qui a ouvert',
  `name` varchar(100) NOT NULL,
  `date_ouverture` datetime DEFAULT current_timestamp(),
  `date_fermeture` datetime DEFAULT NULL,
  `solde_ouverture` decimal(15,2) NOT NULL DEFAULT 0.00,
  `montant` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Solde courant rÚel de la caisse',
  `solde_fermeture` decimal(15,2) NOT NULL DEFAULT 0.00,
  `statut` enum('OUVERTE','FERMEE') NOT NULL DEFAULT 'OUVERTE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `caisses`
--

INSERT INTO `caisses` (`caisse_id`, `entreprise_id`, `succursale_id`, `type_caisse_id`, `mode_paiement_id`, `banque_id`, `user_id`, `name`, `date_ouverture`, `date_fermeture`, `solde_ouverture`, `montant`, `solde_fermeture`, `statut`, `created_at`) VALUES
(11, 9, 8, 14, 1, NULL, 13, 'Caisse fc', '2026-10-09 17:23:22', NULL, 0.00, 168000.00, 0.00, 'OUVERTE', '2026-10-09 15:23:22'),
(16, 12, 12, 19, 1, NULL, 19, 'Caisse $', '2026-10-12 17:23:32', NULL, 0.00, 1142.00, 0.00, 'OUVERTE', '2026-10-12 15:23:32'),
(19, 13, 13, 22, 1, NULL, 20, 'caisse $', '2026-10-20 16:09:39', NULL, 0.00, 506535.00, 0.00, 'OUVERTE', '2026-10-20 14:09:39'),
(20, 13, 14, 22, 1, NULL, 22, 'Caisse $', '2026-10-22 20:29:45', NULL, 0.00, 40.00, 0.00, 'OUVERTE', '2026-10-22 18:29:45'),
(21, 13, 14, 21, 1, NULL, 22, 'Caisse fc', '2026-10-22 20:30:01', NULL, 0.00, 0.00, 0.00, 'OUVERTE', '2026-10-22 18:30:01'),
(23, 13, 14, 22, 3, 3, 22, 'BANQUE COOPEC', '2026-10-26 22:52:10', NULL, 0.00, 0.00, 0.00, 'OUVERTE', '2026-10-26 21:52:10'),
(24, 16, 17, 29, 1, NULL, 27, 'Caisse $', '2026-11-08 15:40:14', NULL, 0.00, 4.00, 0.00, 'OUVERTE', '2026-11-08 14:40:14'),
(25, 18, 19, 30, 1, NULL, 29, 'Caisse $', '2026-11-09 20:50:02', NULL, 0.00, 54.50, 0.00, 'OUVERTE', '2026-11-09 19:50:02');

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`category_id`, `entreprise_id`, `name`, `description`) VALUES
(10, 9, 'Aliment', 'Les aliments '),
(14, 12, 'Gel', ''),
(16, 13, 'Médicaments ', ''),
(17, 16, 'Médecament', ''),
(18, 18, 'Parfum', ''),
(19, 18, 'Tussu', '');

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

CREATE TABLE `clients` (
  `client_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(23) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `comptes_comptables`
--

CREATE TABLE `comptes_comptables` (
  `compte_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `intitule` varchar(160) NOT NULL,
  `classe` tinyint(3) UNSIGNED NOT NULL,
  `nature` enum('DEBIT','CREDIT') NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Structure de la table `demandes_annulation_ecritures`
--

CREATE TABLE `demandes_annulation_ecritures` (
  `demande_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `ecriture_id` bigint(20) NOT NULL,
  `demandeur_id` int(11) DEFAULT NULL,
  `motif` varchar(500) NOT NULL,
  `statut` enum('EN_ATTENTE','APPROUVEE','REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
  `decision_par` int(11) DEFAULT NULL,
  `motif_decision` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `decision_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `demandes_annulation_mouvements_caisse`
--

CREATE TABLE `demandes_annulation_mouvements_caisse` (
  `demande_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `mouvement_id` int(11) NOT NULL,
  `demandeur_id` int(11) DEFAULT NULL,
  `motif` varchar(500) NOT NULL,
  `statut` enum('EN_ATTENTE','APPROUVEE','REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
  `decision_par` int(11) DEFAULT NULL,
  `motif_decision` varchar(500) DEFAULT NULL,
  `mouvement_compensation_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `decision_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `dettes_caisse`
--

CREATE TABLE `dettes_caisse` (
  `dette_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `caisse_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `beneficiaire` varchar(120) NOT NULL,
  `telephone` varchar(43) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `monais` varchar(10) NOT NULL,
  `montant` decimal(15,2) NOT NULL,
  `mouvement_id` int(11) DEFAULT NULL,
  `date_dette` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `ecritures_comptables`
--

CREATE TABLE `ecritures_comptables` (
  `ecriture_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `date_ecriture` date NOT NULL,
  `journal_code` varchar(12) NOT NULL,
  `reference` varchar(120) NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `monnaie` varchar(10) NOT NULL,
  `source_type` varchar(40) DEFAULT NULL,
  `source_id` bigint(20) DEFAULT NULL,
  `statut` enum('BROUILLON','VALIDEE','ANNULEE') NOT NULL DEFAULT 'VALIDEE',
  `user_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `entreprises`
--

CREATE TABLE `entreprises` (
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Nom de l entreprise',
  `activity_type` varchar(30) NOT NULL DEFAULT 'commercial',
  `theme_color` varchar(20) NOT NULL DEFAULT 'teal',
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(23) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `rccm` varchar(100) DEFAULT NULL,
  `boite_postale` varchar(100) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `cachet` varchar(255) DEFAULT NULL,
  `max_succursales` int(11) NOT NULL DEFAULT 2,
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=active, 0=desactivee',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `vente_services_autorisee` tinyint(1) NOT NULL DEFAULT 1,
  `qr_codes_enabled` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `entreprises`
--

INSERT INTO `entreprises` (`entreprise_id`, `name`, `activity_type`, `theme_color`, `email`, `phone`, `address`, `rccm`, `boite_postale`, `logo`, `cachet`, `max_succursales`, `is_active`, `created_at`, `vente_services_autorisee`, `qr_codes_enabled`) VALUES
(9, 'ALIMENTATION SALAMA', 'commercial', 'teal', 'ojcd@gmail.com', '0967289836', 'Oïcha Moba', NULL, NULL, NULL, NULL, 2, 1, '2026-10-09 14:28:41', 1, 0),
(12, 'bcz musienene', 'commercial', 'teal', 'bibihenriet@gmail.com', '0998967065', 'ZS MUSIENENE', NULL, NULL, NULL, NULL, 2, 1, '2026-10-12 15:20:16', 1, 0),
(13, 'ALBERT WORK TECHNOLOGIE', 'commercial', 'green', 'albertwork40@gmail.com', '+243981326086', 'République démocratique du Congo / Nord-kivu /ville de Beni', '', '', 'backend/uploads/companies/13/logo-0b2f3b8dad6d519220700186ccb18bb2.png', 'backend/uploads/companies/13/stamp-f013be8fb0b89b24905da15fdb168155.png', 2, 1, '2026-10-20 10:29:01', 1, 1),
(16, 'NGEKOPHAR', 'pharmaceutical', 'green', 'ngeko@gmail.com', '+243981326086', 'MATONGE', '', '', NULL, NULL, 2, 1, '2026-11-04 18:14:54', 0, 1),
(17, 'SUBIPHARM', 'pharmaceutical', 'green', 'subi@gmail.com', '+243979774456', 'UTSILI', NULL, NULL, NULL, NULL, 2, 1, '2026-11-04 18:16:25', 1, 0),
(18, 'MBO', 'commercial', 'teal', 'jose@gmail.com', '+243967289836', 'République démocratique du Congo', '', '', NULL, NULL, 2, 1, '2026-11-09 19:25:52', 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `entreprise_droits_modules`
--

CREATE TABLE `entreprise_droits_modules` (
  `entreprise_id` int(11) NOT NULL,
  `modules_autorises` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`modules_autorises`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `entreprise_droits_modules`
--

INSERT INTO `entreprise_droits_modules` (`entreprise_id`, `modules_autorises`, `updated_at`) VALUES
(9, '[\"stock\",\"stock_risk\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-11-04 16:14:38'),
(12, '[\"stock\",\"stock_risk\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-11-04 16:14:44'),
(13, '[\"stock\",\"stock_risk\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-11-04 17:19:09'),
(16, '[\"stock\",\"stock_risk\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-11-04 18:20:12'),
(17, '[\"stock\",\"stock_risk\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-11-04 18:19:57'),
(18, '[\"stock\",\"stock_risk\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-11-09 19:27:02');

-- --------------------------------------------------------

--
-- Structure de la table `entreprise_monnaie_reference`
--

CREATE TABLE `entreprise_monnaie_reference` (
  `entreprise_id` int(11) NOT NULL,
  `monais` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `entreprise_monnaie_reference`
--

INSERT INTO `entreprise_monnaie_reference` (`entreprise_id`, `monais`, `created_at`) VALUES
(13, 'USD', '2026-10-22 18:31:20');

-- --------------------------------------------------------

--
-- Structure de la table `fournisseurs`
--

CREATE TABLE `fournisseurs` (
  `fournisseur_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(23) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `fournisseurs`
--

INSERT INTO `fournisseurs` (`fournisseur_id`, `entreprise_id`, `succursale_id`, `name`, `contact_name`, `email`, `phone`, `address`) VALUES
(8, 9, NULL, 'Alberto', '', '', '', ''),
(10, 12, NULL, 'Albert', '', '', '', ''),
(12, 13, NULL, 'David muhasa', '', '', '', '');

-- --------------------------------------------------------

--
-- Structure de la table `jeux_donnees`
--

CREATE TABLE `jeux_donnees` (
  `jeu_donnees_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `secteur_activite` varchar(40) NOT NULL,
  `categorie` varchar(80) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) NOT NULL,
  `created_by_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `jeux_donnees`
--

INSERT INTO `jeux_donnees` (`jeu_donnees_id`, `name`, `description`, `secteur_activite`, `categorie`, `is_active`, `created_by`, `created_by_name`, `created_at`, `updated_at`) VALUES
(1, 'd', '', 'commerce_general', 'JEUX DES DONNEES', 0, 1, 'superAlbert', '2026-11-12 11:02:03', '2026-11-12 14:03:41');

-- --------------------------------------------------------

--
-- Structure de la table `jeux_donnees_importations`
--

CREATE TABLE `jeux_donnees_importations` (
  `importation_id` bigint(20) NOT NULL,
  `jeu_donnees_id` int(11) NOT NULL,
  `jeu_donnees_version_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `branch_name` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `resultat_json` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `jeux_donnees_references`
--

CREATE TABLE `jeux_donnees_references` (
  `reference_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `jeu_donnees_id` int(11) NOT NULL,
  `jeu_donnees_version_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `reference_type` varchar(30) NOT NULL,
  `name` varchar(120) NOT NULL,
  `details_json` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `jeux_donnees_versions`
--

CREATE TABLE `jeux_donnees_versions` (
  `jeu_donnees_version_id` int(11) NOT NULL,
  `jeu_donnees_id` int(11) NOT NULL,
  `version_number` int(11) NOT NULL,
  `items_json` longtext NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_by_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `jeux_donnees_versions`
--

INSERT INTO `jeux_donnees_versions` (`jeu_donnees_version_id`, `jeu_donnees_id`, `version_number`, `items_json`, `created_by`, `created_by_name`, `created_at`) VALUES
(1, 1, 1, '[{\"type\":\"product\",\"name\":\"ll\",\"reference\":\"dk\",\"description\":\"\",\"category\":\"o\",\"unit\":\"p\",\"unit_symbol\":\"p\",\"sale_price\":0,\"cost_price\":0,\"currency\":\"\",\"perishable\":0},{\"type\":\"category\",\"name\":\"dkdk\",\"reference\":\"kkd\",\"description\":\"\",\"category\":\"dk\",\"unit\":\"\",\"unit_symbol\":\"\",\"sale_price\":0,\"cost_price\":0,\"currency\":\"\",\"perishable\":0},{\"type\":\"unit\",\"name\":\"k\",\"reference\":\"\",\"description\":\"\",\"category\":\"\",\"unit\":\"\",\"unit_symbol\":\"\",\"sale_price\":0,\"cost_price\":0,\"currency\":\"\",\"perishable\":0},{\"type\":\"category\",\"name\":\"d\",\"reference\":\"\",\"description\":\"\",\"category\":\"\",\"unit\":\"\",\"unit_symbol\":\"\",\"sale_price\":0,\"cost_price\":0,\"currency\":\"\",\"perishable\":0}]', 1, 'superAlbert', '2026-11-12 11:02:03');

-- --------------------------------------------------------

--
-- Structure de la table `lignes_ecritures_comptables`
--

CREATE TABLE `lignes_ecritures_comptables` (
  `ligne_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `ecriture_id` bigint(20) NOT NULL,
  `compte_id` int(11) NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `debit` decimal(18,2) NOT NULL DEFAULT 0.00,
  `credit` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Structure de la table `modes_paiement`
--

CREATE TABLE `modes_paiement` (
  `mode_paiement_id` int(11) NOT NULL,
  `code` varchar(30) NOT NULL,
  `name` varchar(80) NOT NULL,
  `requires_cash` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `modes_paiement`
--

INSERT INTO `modes_paiement` (`mode_paiement_id`, `code`, `name`, `requires_cash`, `is_active`, `created_at`) VALUES
(1, 'CASH', 'Caisse', 1, 1, '2026-09-28 12:21:37'),
(2, 'MOBILE_MONEY', 'Mobile Money', 0, 1, '2026-09-28 12:21:37'),
(3, 'BANK', 'Banque', 0, 1, '2026-09-28 12:21:37');

-- --------------------------------------------------------

--
-- Structure de la table `mouvements_caisse`
--

CREATE TABLE `mouvements_caisse` (
  `mouvement_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `caisse_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `mode_paiement_id` int(11) DEFAULT NULL,
  `banque_id` int(11) DEFAULT NULL,
  `bank_reference` varchar(120) DEFAULT NULL,
  `type` enum('ENTREE','SORTIE') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `reason` varchar(150) DEFAULT NULL COMMENT 'Vente, Retrait, Depense...',
  `reference_id` int(11) DEFAULT NULL,
  `dette_id` bigint(20) DEFAULT NULL,
  `dette_operation` enum('PRET','REMBOURSEMENT') DEFAULT NULL,
  `movement_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `mouvements_caisse`
--

INSERT INTO `mouvements_caisse` (`mouvement_id`, `entreprise_id`, `caisse_id`, `user_id`, `mode_paiement_id`, `banque_id`, `bank_reference`, `type`, `amount`, `reason`, `reference_id`, `dette_id`, `dette_operation`, `movement_date`) VALUES
(31, 9, 11, 13, 1, NULL, '', 'ENTREE', 50000.00, 'Paiement vente FAC-20261009-MH0F', 18, NULL, NULL, '2026-10-09 17:29:38'),
(32, 9, 11, 13, 1, NULL, '', 'ENTREE', 10000.00, 'Paiement vente FAC-20261009-MH0F', 18, NULL, NULL, '2026-10-09 17:30:58'),
(33, 9, 11, 13, 1, NULL, '', 'ENTREE', 8000.00, 'Paiement vente FAC-20261009-MH0F', 18, NULL, NULL, '2026-10-09 17:31:58'),
(34, 9, 11, 13, 1, NULL, NULL, 'ENTREE', 100000.00, 'Renforcement capital', NULL, NULL, NULL, '2026-10-09 17:34:28'),
(49, 12, 16, 19, 1, NULL, NULL, 'ENTREE', 1000.00, 'Solde antérieur', NULL, NULL, NULL, '2026-10-12 17:24:47'),
(50, 12, 16, 19, 1, NULL, NULL, 'ENTREE', 10.00, 'Fonds Rotatifs PS VUTSUANO', NULL, NULL, NULL, '2026-10-12 17:27:43'),
(51, 12, 16, 19, 1, NULL, NULL, 'ENTREE', 92.00, 'Vente Médic au PS VUTSUANO', NULL, NULL, NULL, '2026-10-12 17:29:13'),
(52, 12, 16, 19, 1, NULL, NULL, 'ENTREE', 20.00, 'Appui Fonct. BCZS CS NGELEZA', NULL, NULL, NULL, '2026-10-12 17:30:17'),
(53, 12, 16, 19, 1, NULL, '', 'ENTREE', 20.00, 'Paiement vente FAC-20261012-VFHL', 26, NULL, NULL, '2026-10-12 18:02:53'),
(85, 13, 19, 20, 1, NULL, '', 'ENTREE', 80.00, 'Paiement vente FAC-20261026-8QXC', 35, NULL, NULL, '2026-10-26 22:47:21'),
(86, 13, 20, 22, 1, NULL, '', 'ENTREE', 20.00, 'Paiement vente FAC-20261026-SO0Z', 34, NULL, NULL, '2026-10-26 22:52:45'),
(87, 13, 20, 22, 1, NULL, '', 'ENTREE', 20.00, 'Paiement vente FAC-20261026-SDT6', 36, NULL, NULL, '2026-10-26 22:52:49'),
(88, 13, 19, 20, 1, NULL, '', 'ENTREE', 506000.00, 'Paiement vente FAC-20261103-R5S0', 37, NULL, NULL, '2026-11-03 09:53:41'),
(89, 13, 19, 20, 1, NULL, '', 'ENTREE', 80.00, 'Paiement vente FAC-20261103-R5S0', 37, NULL, NULL, '2026-11-04 16:35:02'),
(90, 16, 24, 27, 1, NULL, '', 'ENTREE', 4.00, 'Paiement vente FAC-20261105-GJMY', 49, NULL, NULL, '2026-11-08 15:48:24'),
(91, 18, 25, 29, 1, NULL, '', 'ENTREE', 54.50, 'Paiement vente FAC-20261109-IPJX', 53, NULL, NULL, '2026-11-09 20:51:10');

-- --------------------------------------------------------

--
-- Structure de la table `mouvements_stock`
--

CREATE TABLE `mouvements_stock` (
  `mouvement_stock_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `movement_type` enum('ENTREE','SORTIE','AJUSTEMENT') NOT NULL,
  `quantity_before` decimal(15,3) NOT NULL,
  `quantity_moved` decimal(15,3) NOT NULL DEFAULT 0.000,
  `quantity_after` decimal(15,3) NOT NULL,
  `reference_type` varchar(30) NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `movement_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `mouvements_stock`
--

INSERT INTO `mouvements_stock` (`mouvement_stock_id`, `entreprise_id`, `succursale_id`, `produit_id`, `user_id`, `movement_type`, `quantity_before`, `quantity_moved`, `quantity_after`, `reference_type`, `reference_id`, `note`, `movement_date`) VALUES
(51, 9, 8, 13, 13, 'ENTREE', 0.000, 20.000, 20.000, 'APPROVISIONNEMENT', 53, 'Bon d’approvisionnement Zadd', '2026-10-09 16:57:59'),
(52, 9, 8, 12, 13, 'ENTREE', 0.000, 50.000, 50.000, 'APPROVISIONNEMENT', 54, 'Bon d’approvisionnement R5g', '2026-10-09 17:02:36'),
(53, 9, 8, 13, 13, 'SORTIE', 20.000, 5.000, 15.000, 'SORTIE_STOCK', 55, 'Expiration', '2026-10-09 17:08:35'),
(54, 9, 8, 13, 13, 'SORTIE', 15.000, 3.000, 12.000, 'VENTE', 18, 'Vente FAC-20261009-MH0F', '2026-10-09 17:18:51'),
(55, 9, 8, 12, 13, 'SORTIE', 50.000, 20.000, 30.000, 'VENTE', 18, 'Vente FAC-20261009-MH0F', '2026-10-09 17:18:51'),
(76, 12, 12, 19, 19, 'ENTREE', 0.000, 10.000, 10.000, 'APPROVISIONNEMENT', 64, 'Bon d’approvisionnement 1egy', '2026-10-12 17:38:05'),
(77, 12, 12, 19, 19, 'SORTIE', 10.000, 5.000, 5.000, 'VENTE', 26, 'Vente FAC-20261012-VFHL', '2026-10-12 17:40:31'),
(89, 13, 13, 24, 20, 'SORTIE', 22.000, 1.000, 21.000, 'VENTE', 35, 'Vente FAC-20261026-8QXC', '2026-10-26 22:45:41'),
(90, 13, 13, 25, 20, 'ENTREE', 0.000, 10.000, 10.000, 'APPROVISIONNEMENT', 71, 'Bon d’approvisionnement Atg', '2026-11-03 09:32:56'),
(91, 13, 13, 25, 20, 'SORTIE', 10.000, 2.000, 8.000, 'VENTE', 37, 'Vente FAC-20261103-R5S0', '2026-11-03 09:38:03'),
(92, 13, 13, 24, 20, 'SORTIE', 21.000, 1.000, 20.000, 'VENTE', 37, 'Vente FAC-20261103-R5S0', '2026-11-03 09:38:03'),
(93, 13, 14, 27, 22, 'ENTREE', 0.000, 50.000, 50.000, 'APPROVISIONNEMENT', 72, 'Bon d’approvisionnement 1', '2026-11-04 18:33:25'),
(94, 13, 14, 26, 22, 'ENTREE', 0.000, 100.000, 100.000, 'APPROVISIONNEMENT', 74, 'Bon d’approvisionnement Gj', '2026-11-04 18:34:26'),
(95, 13, 14, 26, 22, 'ENTREE', 100.000, 20.000, 120.000, 'APPROVISIONNEMENT', 75, 'Bon d’approvisionnement Y', '2026-11-04 18:34:52'),
(96, 13, 14, 27, 22, 'ENTREE', 50.000, 60.000, 110.000, 'APPROVISIONNEMENT', 73, 'Approvisionnement validé #73', '2026-11-04 18:35:04'),
(97, 13, 14, 27, 22, 'SORTIE', 110.000, 50.000, 60.000, 'VENTE', 38, 'Vente FAC-20261104-8Q89', '2026-11-04 18:36:12'),
(98, 13, 14, 27, 22, 'SORTIE', 60.000, 2.000, 58.000, 'VENTE', 39, 'Vente FAC-20261104-V12X', '2026-11-04 18:36:44'),
(99, 13, 14, 26, 22, 'SORTIE', 120.000, 10.000, 110.000, 'VENTE', 40, 'Vente FAC-20261104-6YE9', '2026-11-04 18:38:14'),
(100, 13, 14, 26, 22, 'ENTREE', 110.000, 19.000, 129.000, 'APPROVISIONNEMENT', 79, 'Approvisionnement validé #79', '2026-11-04 18:43:14'),
(101, 13, 14, 27, 22, 'ENTREE', 58.000, 15.000, 73.000, 'APPROVISIONNEMENT', 78, 'Approvisionnement validé #78', '2026-11-04 18:43:27'),
(102, 13, 14, 26, 22, 'ENTREE', 129.000, 19.000, 148.000, 'APPROVISIONNEMENT', 77, 'Approvisionnement validé #77', '2026-11-04 18:43:41'),
(103, 13, 14, 27, 22, 'ENTREE', 73.000, 15.000, 88.000, 'APPROVISIONNEMENT', 76, 'Approvisionnement validé #76', '2026-11-04 18:43:49'),
(104, 13, 14, 28, 22, 'ENTREE', 0.000, 5.000, 5.000, 'APPROVISIONNEMENT', 80, 'Bon d’approvisionnement Fc', '2026-11-04 18:46:54'),
(105, 13, 14, 28, 22, 'ENTREE', 5.000, 6.000, 11.000, 'APPROVISIONNEMENT', 81, 'Bon d’approvisionnement Fca', '2026-11-04 18:47:27'),
(106, 13, 14, 28, 22, 'SORTIE', 11.000, 1.000, 10.000, 'VENTE', 41, 'Vente FAC-20261104-5V7X', '2026-11-04 18:47:53'),
(107, 13, 14, 28, 22, 'SORTIE', 10.000, 1.000, 9.000, 'VENTE', 42, 'Vente FAC-20261104-FJZJ', '2026-11-04 18:48:12'),
(108, 13, 14, 28, 22, 'SORTIE', 9.000, 1.000, 8.000, 'VENTE', 43, 'Vente FAC-20261104-KM4F', '2026-11-04 18:48:28'),
(109, 13, 13, 29, 20, 'ENTREE', 0.000, 10.000, 10.000, '0', 82, 'Bon d’approvisionnement Fy', '2026-11-05 15:23:32'),
(110, 13, 13, 29, 20, 'SORTIE', 10.000, 5.000, 5.000, '0', 44, 'Vente FAC-20261105-JLT2', '2026-11-05 15:30:09'),
(111, 13, 13, 24, 20, 'SORTIE', 20.000, 1.000, 19.000, '0', 45, 'Vente FAC-20261105-E3RF', '2026-11-05 15:32:11'),
(112, 16, 17, 30, 27, 'ENTREE', 0.000, 50.000, 50.000, '0', 83, 'Bon d’approvisionnement Tj', '2026-11-05 17:27:56'),
(113, 16, 17, 30, 27, 'ENTREE', 50.000, 20.000, 70.000, '0', 84, 'Bon d’approvisionnement Eg', '2026-11-05 17:28:28'),
(114, 16, 17, 30, 27, 'ENTREE', 70.000, 30.000, 100.000, '0', 85, 'Bon d’approvisionnement U', '2026-11-05 17:30:15'),
(115, 16, 17, 30, 27, 'ENTREE', 100.000, 20.000, 120.000, '0', 86, 'Bon d’approvisionnement 13', '2026-11-05 17:31:17'),
(116, 16, 17, 30, 27, 'SORTIE', 120.000, 1.500, 118.500, '0', 46, 'Vente FAC-20261105-3BG3', '2026-11-05 17:31:59'),
(117, 16, 17, 30, 27, 'SORTIE', 118.500, 12.000, 106.500, '0', 47, 'Vente FAC-20261105-HPWC', '2026-11-05 17:32:33'),
(118, 16, 17, 31, 27, 'ENTREE', 0.000, 20.000, 20.000, '0', 87, 'Bon d’approvisionnement 1', '2026-11-05 17:41:02'),
(119, 16, 17, 31, 27, 'ENTREE', 20.000, 5.000, 25.000, '0', 88, 'Bon d’approvisionnement 2', '2026-11-05 17:41:43'),
(120, 16, 17, 31, 27, 'SORTIE', 25.000, 1.000, 24.000, '0', 48, 'Vente FAC-20261105-TJ3D', '2026-11-05 17:42:58'),
(121, 16, 17, 31, 27, 'SORTIE', 24.000, 2.000, 22.000, '0', 49, 'Vente FAC-20261105-GJMY', '2026-11-05 17:43:43'),
(122, 16, 17, 32, 27, 'ENTREE', 0.000, 20.000, 20.000, '0', 89, 'Bon d’approvisionnement R', '2026-11-05 17:46:06'),
(123, 16, 17, 32, 27, 'ENTREE', 20.000, 10.000, 30.000, '0', 90, 'Bon d’approvisionnement Gj', '2026-11-05 17:46:24'),
(124, 16, 17, 32, 27, 'ENTREE', 30.000, 5.000, 35.000, '0', 91, 'Bon d’approvisionnement Tg', '2026-11-05 17:46:50'),
(125, 16, 17, 32, 27, 'SORTIE', 35.000, 1.000, 34.000, '0', 50, 'Vente FAC-20261105-9DTB', '2026-11-05 17:48:52'),
(126, 16, 17, 30, 27, 'SORTIE', 106.500, 2.000, 104.500, '0', 50, 'Vente FAC-20261105-9DTB', '2026-11-05 17:48:52'),
(127, 16, 17, 31, 27, 'SORTIE', 22.000, 1.000, 21.000, '0', 50, 'Vente FAC-20261105-9DTB', '2026-11-05 17:48:52'),
(128, 16, 17, 32, 27, 'SORTIE', 34.000, 3.000, 31.000, '0', 51, 'Vente FAC-20261105-FQB6', '2026-11-05 17:49:54'),
(129, 16, 17, 32, 27, 'SORTIE', 31.000, 5.000, 26.000, '0', 52, 'Vente FAC-20261105-4XHD', '2026-11-05 17:50:38'),
(130, 16, 17, 31, 27, 'ENTREE', 21.000, 30.000, 51.000, '0', 94, 'Bon d’approvisionnement Gjj', '2026-11-05 17:51:58'),
(131, 16, 17, 32, 27, 'ENTREE', 26.000, 10.000, 36.000, '0', 95, 'Bon d’approvisionnement Fv', '2026-11-05 18:07:21'),
(132, 16, 17, 32, 27, 'ENTREE', 36.000, 10.000, 46.000, '0', 96, 'Bon d’approvisionnement Gjh', '2026-11-05 18:08:03'),
(133, 16, 17, 30, 27, 'ENTREE', 104.500, 2.000, 106.500, '0', 97, 'Bon d’approvisionnement Ukkb', '2026-11-05 18:11:02'),
(134, 18, 19, 33, 29, 'ENTREE', 0.000, 12.000, 12.000, '0', 98, 'Bon d’approvisionnement Rsyd', '2026-11-09 20:41:33'),
(135, 18, 19, 34, 29, 'ENTREE', 0.000, 10.000, 10.000, '0', 99, 'Bon d’approvisionnement Du', '2026-11-09 20:42:54'),
(136, 18, 19, 33, 29, 'SORTIE', 12.000, 3.000, 9.000, '0', 53, 'Vente FAC-20261109-IPJX', '2026-11-09 20:47:14'),
(137, 18, 19, 34, 29, 'SORTIE', 10.000, 3.000, 7.000, '0', 53, 'Vente FAC-20261109-IPJX', '2026-11-09 20:47:14');

-- --------------------------------------------------------

--
-- Structure de la table `paiements_dettes_caisse`
--

CREATE TABLE `paiements_dettes_caisse` (
  `paiement_id` bigint(20) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `dette_id` bigint(20) NOT NULL,
  `mouvement_id` int(11) NOT NULL,
  `montant` decimal(15,2) NOT NULL,
  `montant_recu` decimal(15,2) NOT NULL,
  `monais_recue` varchar(10) NOT NULL,
  `taux_change` decimal(20,10) NOT NULL,
  `date_paiement` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `paiements_fournisseurs`
--

CREATE TABLE `paiements_fournisseurs` (
  `paiement_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `achat_id` int(11) NOT NULL,
  `mode_paiement_id` int(11) DEFAULT NULL,
  `banque_id` int(11) DEFAULT NULL,
  `caisse_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `reference` varchar(120) DEFAULT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `paiements_ventes`
--

CREATE TABLE `paiements_ventes` (
  `paiement_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `vente_id` int(11) NOT NULL,
  `mode_paiement_id` int(11) NOT NULL,
  `banque_id` int(11) DEFAULT NULL,
  `caisse_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `amount_applied` decimal(15,2) DEFAULT NULL,
  `monais` varchar(10) DEFAULT NULL,
  `monais_facture` varchar(20) DEFAULT NULL,
  `exchange_rate` decimal(20,10) DEFAULT NULL,
  `reference` varchar(120) DEFAULT NULL,
  `payment_type` enum('PAYMENT','REFUND') NOT NULL DEFAULT 'PAYMENT',
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `paiements_ventes`
--

INSERT INTO `paiements_ventes` (`paiement_id`, `entreprise_id`, `vente_id`, `mode_paiement_id`, `banque_id`, `caisse_id`, `user_id`, `amount`, `amount_applied`, `monais`, `monais_facture`, `exchange_rate`, `reference`, `payment_type`, `payment_date`) VALUES
(17, 9, 18, 1, NULL, 11, 13, 50000.00, 50000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-09 15:29:37'),
(18, 9, 18, 1, NULL, 11, 13, 10000.00, 10000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-09 15:30:58'),
(19, 9, 18, 1, NULL, 11, 13, 8000.00, 8000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-09 15:31:58'),
(34, 12, 26, 1, NULL, 16, 19, 20.00, 20.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-12 16:02:52'),
(45, 13, 35, 1, NULL, 19, 20, 80.00, 80.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-26 21:47:21'),
(46, 13, 34, 1, NULL, 20, 22, 20.00, 20.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-26 21:52:45'),
(47, 13, 36, 1, NULL, 20, 22, 20.00, 20.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-26 21:52:49'),
(48, 13, 37, 1, NULL, 19, 20, 506000.00, 220.00, 'USD', 'CDF', 0.0004347826, '', 'PAYMENT', '2026-11-03 08:53:41'),
(49, 13, 37, 1, NULL, 19, 20, 80.00, 80.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-11-04 15:35:01'),
(50, 16, 49, 1, NULL, 24, 27, 4.00, 4.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-11-08 14:48:24'),
(51, 18, 53, 1, NULL, 25, 29, 54.50, 54.50, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-11-09 19:51:10');

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

CREATE TABLE `produits` (
  `produit_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_origine_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `fournisseur_id` int(11) DEFAULT NULL,
  `sku` varchar(50) NOT NULL COMMENT 'Code barre unique',
  `code_barre` varchar(100) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `unit_price` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Prix de vente',
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Prix d achat',
  `monais` varchar(10) NOT NULL,
  `unite_de_mesure` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `est_perisable` tinyint(1) NOT NULL,
  `quantite_fractionnaire` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`produit_id`, `entreprise_id`, `succursale_origine_id`, `category_id`, `fournisseur_id`, `sku`, `code_barre`, `name`, `description`, `unit_price`, `cost_price`, `monais`, `unite_de_mesure`, `is_active`, `created_at`, `est_perisable`, `quantite_fractionnaire`) VALUES
(12, 9, 8, 10, NULL, 'Riz oni', NULL, 'Riz', '', 0.00, 0.00, 'CDF', 16, 1, '2026-10-09 14:49:46', 0, 0),
(13, 9, 8, 10, NULL, 'Sar', NULL, 'Sardine', '', 0.00, 0.00, 'CDF', 17, 1, '2026-10-09 14:51:38', 1, 0),
(19, 12, 12, 14, NULL, '1', NULL, 'Désinfectant ', '', 0.00, 0.00, 'USD', 20, 1, '2026-10-12 15:35:00', 1, 0),
(24, 13, 13, NULL, NULL, 's', NULL, 'camera', '', 80.00, 0.00, 'USD', 22, 1, '2026-10-25 10:03:33', 0, 0),
(25, 13, 13, NULL, NULL, '13', NULL, 'Ordinateur ', '', 0.00, 0.00, 'CDF', 22, 1, '2026-11-03 08:29:57', 1, 0),
(26, 13, 14, 16, NULL, 'P', NULL, 'Paracetamol', '', 500.00, 300.00, 'CDF', 22, 1, '2026-11-04 17:32:01', 1, 0),
(27, 13, 14, NULL, NULL, 'Kin', NULL, 'Kinine', '', 100.00, 600.00, 'CDF', 22, 1, '2026-11-04 17:32:43', 1, 0),
(28, 13, 14, NULL, NULL, 'Pc', NULL, 'Pc3', '', 100.00, 0.00, 'USD', 22, 1, '2026-11-04 17:45:57', 0, 0),
(29, 13, 13, NULL, NULL, 'M', NULL, 'Moto', '', 1200.00, 0.00, 'USD', 22, 1, '2026-11-05 14:22:30', 0, 0),
(30, 16, 17, NULL, NULL, 'P', NULL, 'Paracetamol', '', 500.00, 300.00, 'CDF', 24, 1, '2026-11-05 15:06:03', 0, 0),
(31, 16, 17, NULL, NULL, '1', NULL, 'Gel', '', 2.00, 1.50, 'USD', 24, 1, '2026-11-05 16:40:26', 0, 0),
(32, 16, 17, NULL, NULL, '12', NULL, 'Pomades', '', 3.00, 1.50, 'USD', 24, 1, '2026-11-05 16:45:33', 1, 0),
(33, 18, 19, 18, NULL, 'B', NULL, 'Bonanza', '', 3.50, 0.00, 'USD', 25, 1, '2026-11-09 19:36:03', 0, 0),
(34, 18, 19, 19, NULL, 'T', NULL, 'Walewale', '', 15.00, 0.00, 'USD', 25, 1, '2026-11-09 19:38:17', 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Ex: ["voir_vente", "creer_produit"]' CHECK (json_valid(`permissions`)),
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `roles`
--

INSERT INTO `roles` (`role_id`, `entreprise_id`, `role_name`, `permissions`, `description`) VALUES
(15, 9, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(16, 9, 'Vendeur', '[\"vente\",\"voir_ventes\",\"creer_ventes\",\"modifier_ventes\",\"stock\",\"voir_stock\",\"modifier_stock\",\"creer_produit\",\"modifier_produit\",\"supprimer_produit\",\"voir_succursales\",\"voir_fournisseurs\",\"creer_fournisseurs\",\"modifier_fournisseurs\",\"supprimer_fournisseurs\",\"voir_approvisionnements\",\"creer_approvisionnements\",\"approvisionnement\"]', ''),
(21, 12, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(22, 13, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(23, 13, 'Vendeur', '[\"vente\",\"voir_ventes\",\"creer_ventes\",\"modifier_ventes\",\"voir_clients\",\"gerer_clients\"]', ''),
(24, 13, 'Caissièr', '[\"caisse\",\"voir_caisse\",\"creer_caisse\",\"modifier_caisse\",\"supprimer_caisse\"]', ''),
(27, 13, 'tous', '[\"vente\",\"voir_ventes\",\"creer_ventes\",\"modifier_ventes\",\"caisse\",\"voir_caisse\",\"creer_caisse\",\"modifier_caisse\",\"supprimer_caisse\",\"stock\",\"voir_stock\",\"modifier_stock\",\"creer_produit\",\"modifier_produit\",\"supprimer_produit\",\"voir_succursales\",\"voir_fournisseurs\",\"creer_fournisseurs\",\"modifier_fournisseurs\",\"supprimer_fournisseurs\",\"voir_approvisionnements\",\"creer_approvisionnements\",\"gestion_risque_stock\",\"voir_risques_stock\",\"approvisionnement\",\"comptabilite\",\"voir_comptabilite\",\"creer_comptabilite\",\"modifier_comptabilite\",\"demandes\",\"gerer_demandes\",\"voir_clients\",\"gerer_clients\"]', ''),
(28, 16, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(29, 17, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(30, 18, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise');

-- --------------------------------------------------------

--
-- Structure de la table `stocks`
--

CREATE TABLE `stocks` (
  `stock_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL DEFAULT 0.000,
  `min_stock_level` decimal(15,3) NOT NULL DEFAULT 5.000,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `stocks`
--

INSERT INTO `stocks` (`stock_id`, `entreprise_id`, `succursale_id`, `produit_id`, `quantity`, `min_stock_level`, `updated_at`) VALUES
(37, 9, 8, 12, 30.000, 10.000, '2026-10-09 15:18:51'),
(38, 9, 8, 13, 12.000, 5.000, '2026-10-09 15:18:51'),
(53, 12, 12, 19, 5.000, 5.000, '2026-10-12 15:40:31'),
(64, 13, 13, 24, 19.000, 5.000, '2026-11-05 14:32:11'),
(67, 13, 13, 25, 8.000, 5.000, '2026-11-03 08:38:03'),
(70, 13, 14, 26, 148.000, 5.000, '2026-11-04 17:43:41'),
(71, 13, 14, 27, 88.000, 5.000, '2026-11-04 17:43:49'),
(83, 13, 14, 28, 8.000, 5.000, '2026-11-04 17:48:28'),
(86, 13, 13, 29, 5.000, 5.000, '2026-11-05 14:30:09'),
(88, 16, 17, 30, 106.500, 5.000, '2026-11-05 17:11:02'),
(95, 16, 17, 31, 51.000, 5.000, '2026-11-05 16:51:58'),
(98, 16, 17, 32, 46.000, 10.000, '2026-11-05 17:08:03'),
(110, 18, 19, 33, 9.000, 5.000, '2026-11-09 19:47:14'),
(111, 18, 19, 34, 7.000, 5.000, '2026-11-09 19:47:14');

-- --------------------------------------------------------

--
-- Structure de la table `succursales`
--

CREATE TABLE `succursales` (
  `succursale_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL COMMENT 'A quelle entreprise appartient cette succursale',
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Ex: GOMA-01, BUKA-01',
  `est_sucursal_mere` tinyint(1) NOT NULL DEFAULT 0,
  `partager_produits_mere` tinyint(1) NOT NULL DEFAULT 1,
  `address` text DEFAULT NULL,
  `phone` varchar(23) DEFAULT NULL,
  `vente_services_autorisee` tinyint(1) NOT NULL DEFAULT 1,
  `qr_codes_enabled` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `succursales`
--

INSERT INTO `succursales` (`succursale_id`, `entreprise_id`, `name`, `code`, `est_sucursal_mere`, `partager_produits_mere`, `address`, `phone`, `vente_services_autorisee`, `qr_codes_enabled`) VALUES
(8, 9, 'ALIMENTATION SALAMA', 'MERE', 1, 1, 'Oïcha Moba', '0967289836', 1, 0),
(12, 12, 'bcz musienene', 'MERE', 1, 1, 'ZS MUSIENENE', '0998967065', 1, 0),
(13, 13, 'ALBERT WORK', 'MERE', 1, 1, 'République démocratique du Congo / Nord-kivu /ville de Beni', '+243981326086', 1, 0),
(14, 13, 'Matonge', '40', 0, 0, 'Ville de beni quartier matonge', '+243981326086', 1, 0),
(17, 16, 'NGEKOPHAR', 'MERE', 1, 1, 'MATONGE', '+2439813260', 1, 0),
(18, 17, 'SUBIPHARM', 'MERE', 1, 1, 'UTSILI', '+243979774456', 1, 0),
(19, 18, 'MBO', 'MERE', 1, 1, 'République démocratique du Congo', '+243967289836', 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `super_admins`
--

CREATE TABLE `super_admins` (
  `super_admin_id` int(11) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `preferred_language` varchar(5) NOT NULL DEFAULT 'fr',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `super_admins`
--

INSERT INTO `super_admins` (`super_admin_id`, `email`, `password_hash`, `full_name`, `is_active`, `preferred_language`, `created_at`) VALUES
(1, 'admin@gmail.com', '$2y$10$0HOmG7bF5gbXQqmXRDGa7ONEA6QtgJtEktt4qgJ4maGwrJLzU4ni2', 'superAlbert', 1, 'fr', '2026-09-23 19:58:15');

-- --------------------------------------------------------

--
-- Structure de la table `super_admin_notification_emails`
--

CREATE TABLE `super_admin_notification_emails` (
  `email` varchar(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `super_admin_notification_emails`
--

INSERT INTO `super_admin_notification_emails` (`email`, `created_at`) VALUES
('admin@gmail.com', '2026-10-24 16:53:26'),
('albertwork40@gmail.com', '2026-10-24 16:53:26');

-- --------------------------------------------------------

--
-- Structure de la table `super_admin_notification_settings`
--

CREATE TABLE `super_admin_notification_settings` (
  `setting_id` tinyint(3) UNSIGNED NOT NULL,
  `registration_email` varchar(150) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `super_admin_notification_settings`
--

INSERT INTO `super_admin_notification_settings` (`setting_id`, `registration_email`, `updated_at`) VALUES
(1, NULL, '2026-10-24 13:32:52');

-- --------------------------------------------------------

--
-- Structure de la table `taux_change`
--

CREATE TABLE `taux_change` (
  `taux_change_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `monais` varchar(20) NOT NULL,
  `taux_vers_reference` decimal(20,10) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Déchargement des données de la table `taux_change`
--

INSERT INTO `taux_change` (`taux_change_id`, `entreprise_id`, `monais`, `taux_vers_reference`, `updated_by`, `created_at`, `updated_at`) VALUES
(11, 13, 'CDF', 2300.0000000000, 22, '2026-10-22 18:31:32', '2026-10-22 18:31:32');

-- --------------------------------------------------------

--
-- Structure de la table `tb_monais`
--

CREATE TABLE `tb_monais` (
  `type_monais` varchar(20) NOT NULL,
  `description` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tb_monais`
--

INSERT INTO `tb_monais` (`type_monais`, `description`) VALUES
('CDF', 'Fc'),
('USD', '$');

-- --------------------------------------------------------

--
-- Structure de la table `transferts_stock`
--

CREATE TABLE `transferts_stock` (
  `transfert_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `succursale_from_id` int(11) NOT NULL COMMENT 'Source',
  `succursale_to_id` int(11) NOT NULL COMMENT 'Destination',
  `quantity` decimal(15,3) NOT NULL,
  `transfer_date` datetime DEFAULT current_timestamp(),
  `status` varchar(20) DEFAULT 'COMPLETED',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `types_caisses`
--

CREATE TABLE `types_caisses` (
  `type_caisse_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL COMMENT 'USD, CDF',
  `name` varchar(50) NOT NULL,
  `symbole` varchar(10) NOT NULL COMMENT '$, FC',
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `types_caisses`
--

INSERT INTO `types_caisses` (`type_caisse_id`, `entreprise_id`, `code`, `name`, `symbole`, `description`, `is_active`, `created_at`) VALUES
(14, 9, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-10-09 15:23:22'),
(19, 12, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-10-12 15:23:31'),
(21, 13, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-10-20 14:09:06'),
(22, 13, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-10-20 14:09:39'),
(29, 16, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-11-08 14:40:13'),
(30, 18, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-11-09 19:49:59');

-- --------------------------------------------------------

--
-- Structure de la table `unites_mesure`
--

CREATE TABLE `unites_mesure` (
  `unite_mesure_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `abbreviation` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `symbole` varchar(15) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `unites_mesure`
--

INSERT INTO `unites_mesure` (`unite_mesure_id`, `entreprise_id`, `name`, `abbreviation`, `created_at`, `symbole`) VALUES
(16, 9, 'Kilogramme', '', '2026-10-09 14:43:01', 'Kg'),
(17, 9, 'Pièces', '', '2026-10-09 14:50:32', 'Pcs'),
(20, 12, 'Pièces', '', '2026-10-12 15:30:18', 'Pcs'),
(21, 12, 'Kilogramme', '', '2026-10-12 15:30:54', 'Kg'),
(22, 13, 'Pièces', '', '2026-10-20 10:31:45', 'Pcs'),
(23, 13, 'Un', '', '2026-10-20 10:32:13', '1'),
(24, 16, 'Pièces', '', '2026-11-05 15:05:01', 'Pcs'),
(25, 18, 'Piece', '', '2026-11-09 19:33:25', 'Pc'),
(26, 18, 'Douzaine', '', '2026-11-09 19:34:26', 'Dz');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) DEFAULT NULL COMMENT 'NULL = a acces a toutes les succursales',
  `role_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(500) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `preferred_language` varchar(5) NOT NULL DEFAULT 'fr',
  `interface_theme` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`user_id`, `entreprise_id`, `succursale_id`, `role_id`, `username`, `email`, `password_hash`, `full_name`, `is_active`, `preferred_language`, `interface_theme`, `created_at`) VALUES
(13, 9, 8, 15, 'Ojcd', 'ojcd@gmail.com', '$2y$10$8qAErnqdb1vNzpyOXG/COOUZBqT1F/BnLFy0s6tsRiuEU0mrH5uhG', 'Musien Hopital', 1, 'fr', NULL, '2026-10-09 14:28:41'),
(14, 9, NULL, 16, 'Zadock', 'zadock@gmail.com', '$2y$10$7XMDlX1W9hNnZYM1uP6kvuX7ImCI5jW.fGr0qw0a0eUWd5uZbRZwS', 'Zadock', 1, 'fr', NULL, '2026-10-09 14:38:44'),
(19, 12, 12, 21, 'BCZ MUSIENENE', 'bibihenriet@gmail.com', '$2y$10$2j.dUM5ctBVZsAl8MbAGSO1X61/Oqjt3viZTfPhMy8kluVeMda7Em', 'Henriette Bibisombe', 1, 'fr', NULL, '2026-10-12 15:20:16'),
(20, 13, 13, 22, 'alberson', 'albertwork40@gmail.com', '$2y$10$Gq8DHxvhu3yVx7yWYCug1exkEfkGlHmrPAHrt34OALatsAlb3axEy', 'Albert', 1, 'fr', 'black', '2026-10-20 10:29:02'),
(21, 13, 14, 22, 'Vd', 'vd@gmail.com', '$2y$10$a/lrhmoBX8y6Z07OCTNqk.LabRmQEu8J6tiIrc1DJ5mLZ22GECKPm', 'Vendeur', 1, 'fr', NULL, '2026-10-22 18:05:43'),
(22, 13, 14, 27, 'James', 'jm@gmail.com', '$2y$10$xvc0eso8hWsdxaRg7PR4c.cPQLxtCntXApzl03wV2T8LaUj/mCvdG', 'Jm', 1, 'fr', 'blue', '2026-10-22 18:06:26'),
(23, 13, 13, 23, 'Ad', 'ad@gmail.com', '$2y$10$GpsoOGcFpNnEihL3H1fRJuuf8VAyH9spMj6pWfGCdZ/WDsDeWFthm', 'Ad', 1, 'fr', NULL, '2026-10-22 18:39:57'),
(27, 16, 17, 28, 'ngeko', 'ngeko@gmail.com', '$2y$10$2At7BPX09cWdsxQ2Wc7bK.iQtf8w9VLtKVYFUGT5rH0H65EI6djYe', 'NGEKO', 1, 'fr', 'gray', '2026-11-04 18:14:55'),
(28, 17, 18, 29, 'subi', 'subi@gmail.com', '$2y$10$AFsMcXiA53I2WLJQEFfcjuTuLDUprL/IAQdSFigSINO3II2A2gDyC', 'SUBI', 1, 'fr', NULL, '2026-11-04 18:16:25'),
(29, 18, 19, 30, 'jose', 'jose@gmail.com', '$2y$10$z5brusN5XoK1w0ngGDXGvuvmcwMk4/c6VqqJxUhJr6tdwqqgPTRVC', 'José mbo', 1, 'fr', 'blue', '2026-11-09 19:25:52');

-- --------------------------------------------------------

--
-- Structure de la table `ventes`
--

CREATE TABLE `ventes` (
  `vente_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `caisse_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `client_comptoir_name` varchar(100) DEFAULT NULL,
  `invoice_no` varchar(50) NOT NULL COMMENT 'Ex: FACT-2026-0001',
  `sale_date` datetime DEFAULT current_timestamp(),
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `monais` varchar(10) DEFAULT NULL,
  `amount_paid` decimal(15,2) NOT NULL DEFAULT 0.00,
  `status` enum('PENDING','PAID','PARTIAL','CANCELLED') NOT NULL DEFAULT 'PAID',
  `cancellation_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `ventes`
--

INSERT INTO `ventes` (`vente_id`, `entreprise_id`, `succursale_id`, `caisse_id`, `user_id`, `client_id`, `client_comptoir_name`, `invoice_no`, `sale_date`, `total_amount`, `monais`, `amount_paid`, `status`, `cancellation_date`, `created_at`) VALUES
(18, 9, 8, NULL, 13, NULL, 'Isaac', 'FAC-20261009-MH0F', '2026-10-09 17:18:51', 68000.00, 'CDF', 68000.00, 'PAID', NULL, '2026-10-09 15:18:51'),
(26, 12, 12, NULL, 19, NULL, 'Ndaliko', 'FAC-20261012-VFHL', '2026-10-12 17:40:31', 60.00, 'USD', 20.00, 'PARTIAL', NULL, '2026-10-12 15:40:31'),
(34, 13, 14, NULL, 20, NULL, 'MWERA TECH', 'FAC-20261026-SO0Z', '2026-10-26 22:33:39', 20.00, 'USD', 20.00, 'PAID', NULL, '2026-10-26 21:33:39'),
(35, 13, 13, NULL, 20, NULL, 'Jm', 'FAC-20261026-8QXC', '2026-10-26 22:45:40', 80.00, 'USD', 80.00, 'PAID', NULL, '2026-10-26 21:45:40'),
(36, 13, 14, NULL, 20, NULL, 'Ob', 'FAC-20261026-SDT6', '2026-10-26 22:46:02', 20.00, 'USD', 20.00, 'PAID', NULL, '2026-10-26 21:46:02'),
(37, 13, 13, NULL, 20, NULL, NULL, 'FAC-20261103-R5S0', '2026-11-03 09:38:03', 0.00, NULL, 0.00, 'PAID', NULL, '2026-11-03 08:38:03'),
(38, 13, 14, NULL, 22, NULL, 'Albrt', 'FAC-20261104-8Q89', '2026-11-04 18:36:11', 5000.00, 'CDF', 0.00, 'PENDING', NULL, '2026-11-04 17:36:11'),
(39, 13, 14, NULL, 22, NULL, 'Saline', 'FAC-20261104-V12X', '2026-11-04 18:36:44', 200.00, 'CDF', 0.00, 'PENDING', NULL, '2026-11-04 17:36:44'),
(40, 13, 14, NULL, 22, NULL, 'Alberson', 'FAC-20261104-6YE9', '2026-11-04 18:38:14', 5000.00, 'CDF', 0.00, 'PENDING', NULL, '2026-11-04 17:38:14'),
(41, 13, 14, NULL, 22, NULL, 'Alberson', 'FAC-20261104-5V7X', '2026-11-04 18:47:53', 100.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-04 17:47:53'),
(42, 13, 14, NULL, 22, NULL, 'Ob', 'FAC-20261104-FJZJ', '2026-11-04 18:48:12', 100.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-04 17:48:12'),
(43, 13, 14, NULL, 22, NULL, 'Obed', 'FAC-20261104-KM4F', '2026-11-04 18:48:28', 100.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-04 17:48:28'),
(44, 13, 13, NULL, 20, NULL, 'Th', 'FAC-20261105-JLT2', '2026-11-05 15:30:09', 6000.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-05 14:30:09'),
(45, 13, 13, NULL, 20, NULL, 'H', 'FAC-20261105-E3RF', '2026-11-05 15:32:11', 80.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-05 14:32:11'),
(46, 16, 17, NULL, 27, NULL, 'Jms', 'FAC-20261105-3BG3', '2026-11-05 17:31:59', 750.00, 'CDF', 0.00, 'PENDING', NULL, '2026-11-05 16:31:59'),
(47, 16, 17, NULL, 27, NULL, 'Jms', 'FAC-20261105-HPWC', '2026-11-05 17:32:33', 6000.00, 'CDF', 0.00, 'PENDING', NULL, '2026-11-05 16:32:33'),
(48, 16, 17, NULL, 27, NULL, 'A', 'FAC-20261105-TJ3D', '2026-11-05 17:42:58', 2.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-05 16:42:58'),
(49, 16, 17, NULL, 27, NULL, 'B', 'FAC-20261105-GJMY', '2026-11-05 17:43:43', 4.00, 'USD', 4.00, 'PAID', NULL, '2026-11-05 16:43:43'),
(50, 16, 17, NULL, 27, NULL, 'Al', 'FAC-20261105-9DTB', '2026-11-05 17:48:51', 0.00, NULL, 0.00, 'PENDING', NULL, '2026-11-05 16:48:51'),
(51, 16, 17, NULL, 27, NULL, 'O', 'FAC-20261105-FQB6', '2026-11-05 17:49:54', 9.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-05 16:49:54'),
(52, 16, 17, NULL, 27, NULL, 'T', 'FAC-20261105-4XHD', '2026-11-05 17:50:37', 15.00, 'USD', 0.00, 'PENDING', NULL, '2026-11-05 16:50:37'),
(53, 18, 19, NULL, 29, NULL, 'James', 'FAC-20261109-IPJX', '2026-11-09 20:47:12', 54.50, 'USD', 54.50, 'PAID', NULL, '2026-11-09 19:47:12');

-- --------------------------------------------------------

--
-- Structure de la table `vente_details`
--

CREATE TABLE `vente_details` (
  `vente_detail_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `vente_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `monais` varchar(10) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vente_details`
--

INSERT INTO `vente_details` (`vente_detail_id`, `entreprise_id`, `vente_id`, `produit_id`, `monais`, `quantity`, `unit_price`, `discount_percent`, `subtotal`, `discount_amount`, `created_at`) VALUES
(25, 9, 18, 13, 'CDF', 3.000, 1500.00, 4.44, 4300.00, 200.00, '2026-10-09 15:18:51'),
(26, 9, 18, 12, 'CDF', 20.000, 3200.00, 0.47, 63700.00, 300.00, '2026-10-09 15:18:51'),
(39, 12, 26, 19, 'USD', 5.000, 12.00, 0.00, 60.00, 0.00, '2026-10-12 15:40:31'),
(43, 13, 35, 24, 'USD', 1.000, 80.00, 0.00, 80.00, 0.00, '2026-10-26 21:45:41'),
(44, 13, 37, 25, 'CDF', 2.000, 120.00, 8.33, 220.00, 20.00, '2026-11-03 08:38:03'),
(45, 13, 37, 24, 'USD', 1.000, 80.00, 0.00, 80.00, 0.00, '2026-11-03 08:38:03'),
(46, 13, 38, 27, 'CDF', 50.000, 100.00, 0.00, 5000.00, 0.00, '2026-11-04 17:36:12'),
(47, 13, 39, 27, 'CDF', 2.000, 100.00, 0.00, 200.00, 0.00, '2026-11-04 17:36:44'),
(48, 13, 40, 26, 'CDF', 10.000, 500.00, 0.00, 5000.00, 0.00, '2026-11-04 17:38:14'),
(49, 13, 41, 28, 'USD', 1.000, 100.00, 0.00, 100.00, 0.00, '2026-11-04 17:47:53'),
(50, 13, 42, 28, 'USD', 1.000, 100.00, 0.00, 100.00, 0.00, '2026-11-04 17:48:12'),
(51, 13, 43, 28, 'USD', 1.000, 100.00, 0.00, 100.00, 0.00, '2026-11-04 17:48:28'),
(52, 13, 44, 29, 'USD', 5.000, 1200.00, 0.00, 6000.00, 0.00, '2026-11-05 14:30:09'),
(53, 13, 45, 24, 'USD', 1.000, 80.00, 0.00, 80.00, 0.00, '2026-11-05 14:32:11'),
(54, 16, 46, 30, 'CDF', 1.500, 500.00, 0.00, 750.00, 0.00, '2026-11-05 16:31:59'),
(55, 16, 47, 30, 'CDF', 12.000, 500.00, 0.00, 6000.00, 0.00, '2026-11-05 16:32:33'),
(56, 16, 48, 31, 'USD', 1.000, 2.00, 0.00, 2.00, 0.00, '2026-11-05 16:42:58'),
(57, 16, 49, 31, 'USD', 2.000, 2.00, 0.00, 4.00, 0.00, '2026-11-05 16:43:43'),
(58, 16, 50, 32, 'USD', 1.000, 3.00, 0.00, 3.00, 0.00, '2026-11-05 16:48:51'),
(59, 16, 50, 30, 'CDF', 2.000, 500.00, 0.00, 1000.00, 0.00, '2026-11-05 16:48:52'),
(60, 16, 50, 31, 'USD', 1.000, 2.00, 0.00, 2.00, 0.00, '2026-11-05 16:48:52'),
(61, 16, 51, 32, 'USD', 3.000, 3.00, 0.00, 9.00, 0.00, '2026-11-05 16:49:54'),
(62, 16, 52, 32, 'USD', 5.000, 3.00, 0.00, 15.00, 0.00, '2026-11-05 16:50:38'),
(63, 18, 53, 33, 'USD', 3.000, 3.50, 9.52, 9.50, 1.00, '2026-11-09 19:47:14'),
(64, 18, 53, 34, 'USD', 3.000, 15.00, 0.00, 45.00, 0.00, '2026-11-09 19:47:14');

-- --------------------------------------------------------

--
-- Structure de la table `vente_detail_lots`
--

CREATE TABLE `vente_detail_lots` (
  `vente_detail_lot_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `vente_detail_id` int(11) NOT NULL,
  `achat_detail_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vente_detail_lots`
--

INSERT INTO `vente_detail_lots` (`vente_detail_lot_id`, `entreprise_id`, `vente_detail_id`, `achat_detail_id`, `quantity`, `created_at`) VALUES
(6, 9, 25, 32, 3.000, '2026-10-09 15:18:51'),
(8, 12, 39, 43, 5.000, '2026-10-12 15:40:31'),
(9, 13, 44, 50, 2.000, '2026-11-03 08:38:03'),
(10, 13, 46, 52, 50.000, '2026-11-04 17:36:12'),
(11, 13, 47, 52, 2.000, '2026-11-04 17:36:44'),
(12, 13, 48, 54, 10.000, '2026-11-04 17:38:14'),
(13, 16, 54, 65, 1.500, '2026-11-05 16:31:59'),
(14, 16, 55, 65, 12.000, '2026-11-05 16:32:33'),
(15, 16, 58, 68, 1.000, '2026-11-05 16:48:51'),
(16, 16, 59, 65, 2.000, '2026-11-05 16:48:52'),
(17, 16, 61, 68, 3.000, '2026-11-05 16:49:54'),
(18, 16, 62, 68, 5.000, '2026-11-05 16:50:38');

-- --------------------------------------------------------

--
-- Structure de la table `vente_service_details`
--

CREATE TABLE `vente_service_details` (
  `vente_service_detail_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `vente_id` int(11) NOT NULL,
  `service_name` varchar(150) NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `discount_percent` decimal(7,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `monais` varchar(10) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vente_service_details`
--

INSERT INTO `vente_service_details` (`vente_service_detail_id`, `entreprise_id`, `vente_id`, `service_name`, `quantity`, `unit_price`, `discount_percent`, `discount_amount`, `monais`, `subtotal`, `created_at`) VALUES
(5, 13, 34, 'Installation du wifi zone à matonge', 1.000, 20.00, 0.00, 0.00, 'USD', 20.00, '2026-10-26 21:33:41'),
(6, 13, 36, 'Jj', 1.000, 20.00, 0.00, 0.00, 'USD', 20.00, '2026-10-26 21:46:02');

-- --------------------------------------------------------

--
-- Structure de la table `vente_totaux_monnaies`
--

CREATE TABLE `vente_totaux_monnaies` (
  `entreprise_id` int(11) NOT NULL,
  `vente_id` int(11) NOT NULL,
  `monais` varchar(10) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(15,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vente_totaux_monnaies`
--

INSERT INTO `vente_totaux_monnaies` (`entreprise_id`, `vente_id`, `monais`, `total_amount`, `amount_paid`) VALUES
(9, 18, 'CDF', 68000.00, 68000.00),
(12, 26, 'USD', 60.00, 20.00),
(13, 34, 'USD', 20.00, 20.00),
(13, 35, 'USD', 80.00, 80.00),
(13, 36, 'USD', 20.00, 20.00),
(13, 37, 'CDF', 220.00, 220.00),
(13, 37, 'USD', 80.00, 80.00),
(13, 38, 'CDF', 5000.00, 0.00),
(13, 39, 'CDF', 200.00, 0.00),
(13, 40, 'CDF', 5000.00, 0.00),
(13, 41, 'USD', 100.00, 0.00),
(13, 42, 'USD', 100.00, 0.00),
(13, 43, 'USD', 100.00, 0.00),
(13, 44, 'USD', 6000.00, 0.00),
(13, 45, 'USD', 80.00, 0.00),
(16, 46, 'CDF', 750.00, 0.00),
(16, 47, 'CDF', 6000.00, 0.00),
(16, 48, 'USD', 2.00, 0.00),
(16, 49, 'USD', 4.00, 4.00),
(16, 50, 'CDF', 1000.00, 0.00),
(16, 50, 'USD', 5.00, 0.00),
(16, 51, 'USD', 9.00, 0.00),
(16, 52, 'USD', 15.00, 0.00),
(18, 53, 'USD', 54.50, 54.50);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `achats`
--
ALTER TABLE `achats`
  ADD PRIMARY KEY (`achat_id`),
  ADD UNIQUE KEY `uq_purchase_no` (`entreprise_id`,`purchase_no`),
  ADD KEY `fk_achat_succursale` (`succursale_id`),
  ADD KEY `fk_achat_fournisseur` (`fournisseur_id`),
  ADD KEY `fk_achat_user` (`user_id`);

--
-- Index pour la table `achat_details`
--
ALTER TABLE `achat_details`
  ADD PRIMARY KEY (`achat_detail_id`),
  ADD KEY `fk_achat_detail_entreprise` (`entreprise_id`),
  ADD KEY `fk_achat_detail_achat` (`achat_id`),
  ADD KEY `fk_achat_detail_produit` (`produit_id`);

--
-- Index pour la table `achat_detail_sorties`
--
ALTER TABLE `achat_detail_sorties`
  ADD PRIMARY KEY (`sortie_id`),
  ADD KEY `idx_sortie_lot` (`entreprise_id`,`lot_detail_id`),
  ADD KEY `fk_sortie_detail_achat_detail` (`sortie_detail_id`),
  ADD KEY `fk_sortie_detail_lot` (`lot_detail_id`);

--
-- Index pour la table `banques`
--
ALTER TABLE `banques`
  ADD PRIMARY KEY (`banque_id`),
  ADD UNIQUE KEY `uq_banque_entreprise_compte` (`entreprise_id`,`name`,`account_number`);

--
-- Index pour la table `bons_commande_previsionnels`
--
ALTER TABLE `bons_commande_previsionnels`
  ADD PRIMARY KEY (`bon_previsionnel_id`),
  ADD UNIQUE KEY `uq_bon_previsionnel_reference` (`entreprise_id`,`reference`),
  ADD KEY `idx_bon_previsionnel_branch` (`entreprise_id`,`succursale_id`,`status`,`created_at`),
  ADD KEY `fk_bon_previsionnel_succursale` (`succursale_id`),
  ADD KEY `fk_bon_previsionnel_user` (`user_id`);

--
-- Index pour la table `bon_commande_previsionnel_details`
--
ALTER TABLE `bon_commande_previsionnel_details`
  ADD PRIMARY KEY (`detail_previsionnel_id`),
  ADD KEY `idx_bon_previsionnel_details` (`entreprise_id`,`bon_previsionnel_id`),
  ADD KEY `fk_bon_previsionnel_detail_bon` (`bon_previsionnel_id`),
  ADD KEY `fk_bon_previsionnel_detail_produit` (`produit_id`),
  ADD KEY `fk_bon_previsionnel_detail_fournisseur` (`fournisseur_id`);

--
-- Index pour la table `caisses`
--
ALTER TABLE `caisses`
  ADD PRIMARY KEY (`caisse_id`),
  ADD KEY `fk_caisse_succursale` (`succursale_id`),
  ADD KEY `fk_caisse_type` (`type_caisse_id`),
  ADD KEY `fk_caisse_user` (`user_id`),
  ADD KEY `fk_caisse_mode_paiement` (`mode_paiement_id`),
  ADD KEY `idx_caisses_mode_ouverte` (`entreprise_id`,`succursale_id`,`type_caisse_id`,`mode_paiement_id`,`statut`),
  ADD KEY `fk_caisse_banque` (`banque_id`),
  ADD KEY `idx_caisses_banque` (`entreprise_id`,`banque_id`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `uq_category_name` (`entreprise_id`,`name`);

--
-- Index pour la table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`client_id`),
  ADD KEY `fk_client_entreprise` (`entreprise_id`);

--
-- Index pour la table `comptes_comptables`
--
ALTER TABLE `comptes_comptables`
  ADD PRIMARY KEY (`compte_id`),
  ADD UNIQUE KEY `uq_compte_entreprise_code` (`entreprise_id`,`code`),
  ADD KEY `idx_compte_parent` (`entreprise_id`,`parent_id`),
  ADD KEY `fk_compte_parent` (`parent_id`);

--
-- Index pour la table `demandes_annulation_ecritures`
--
ALTER TABLE `demandes_annulation_ecritures`
  ADD PRIMARY KEY (`demande_id`),
  ADD KEY `idx_demande_annulation_statut` (`entreprise_id`,`statut`,`created_at`),
  ADD KEY `idx_demande_annulation_ecriture` (`entreprise_id`,`ecriture_id`,`statut`),
  ADD KEY `fk_demande_annulation_ecriture` (`ecriture_id`),
  ADD KEY `fk_demande_annulation_demandeur` (`demandeur_id`),
  ADD KEY `fk_demande_annulation_decisionnaire` (`decision_par`);

--
-- Index pour la table `demandes_annulation_mouvements_caisse`
--
ALTER TABLE `demandes_annulation_mouvements_caisse`
  ADD PRIMARY KEY (`demande_id`),
  ADD KEY `idx_demande_caisse_statut` (`entreprise_id`,`statut`,`created_at`),
  ADD KEY `idx_demande_caisse_mouvement` (`entreprise_id`,`mouvement_id`,`statut`),
  ADD KEY `fk_demande_caisse_mouvement` (`mouvement_id`),
  ADD KEY `fk_demande_caisse_demandeur` (`demandeur_id`),
  ADD KEY `fk_demande_caisse_decisionnaire` (`decision_par`),
  ADD KEY `fk_demande_caisse_compensation` (`mouvement_compensation_id`);

--
-- Index pour la table `dettes_caisse`
--
ALTER TABLE `dettes_caisse`
  ADD PRIMARY KEY (`dette_id`),
  ADD UNIQUE KEY `uq_dettes_caisse_mouvement` (`entreprise_id`,`mouvement_id`),
  ADD KEY `idx_dettes_caisse_page` (`entreprise_id`,`succursale_id`,`date_dette`,`dette_id`);

--
-- Index pour la table `ecritures_comptables`
--
ALTER TABLE `ecritures_comptables`
  ADD PRIMARY KEY (`ecriture_id`),
  ADD UNIQUE KEY `uq_ecriture_source` (`entreprise_id`,`source_type`,`source_id`),
  ADD KEY `idx_ecriture_date` (`entreprise_id`,`monnaie`,`date_ecriture`,`journal_code`),
  ADD KEY `fk_ecriture_user` (`user_id`);

--
-- Index pour la table `entreprises`
--
ALTER TABLE `entreprises`
  ADD PRIMARY KEY (`entreprise_id`);

--
-- Index pour la table `entreprise_droits_modules`
--
ALTER TABLE `entreprise_droits_modules`
  ADD PRIMARY KEY (`entreprise_id`);

--
-- Index pour la table `entreprise_monnaie_reference`
--
ALTER TABLE `entreprise_monnaie_reference`
  ADD PRIMARY KEY (`entreprise_id`),
  ADD KEY `fk_monnaie_reference_code` (`monais`);

--
-- Index pour la table `fournisseurs`
--
ALTER TABLE `fournisseurs`
  ADD PRIMARY KEY (`fournisseur_id`),
  ADD KEY `fk_fournisseur_entreprise` (`entreprise_id`),
  ADD KEY `fk_fournisseur_succursale` (`succursale_id`);

--
-- Index pour la table `jeux_donnees`
--
ALTER TABLE `jeux_donnees`
  ADD PRIMARY KEY (`jeu_donnees_id`),
  ADD KEY `idx_jeux_donnees_catalogue` (`is_active`,`secteur_activite`,`categorie`);

--
-- Index pour la table `jeux_donnees_importations`
--
ALTER TABLE `jeux_donnees_importations`
  ADD PRIMARY KEY (`importation_id`),
  ADD KEY `idx_jeu_import_entreprise` (`entreprise_id`,`created_at`),
  ADD KEY `fk_jeu_import_dataset` (`jeu_donnees_id`),
  ADD KEY `fk_jeu_import_version` (`jeu_donnees_version_id`),
  ADD KEY `idx_jeu_import_user` (`user_id`),
  ADD KEY `idx_jeu_import_branch` (`succursale_id`);

--
-- Index pour la table `jeux_donnees_references`
--
ALTER TABLE `jeux_donnees_references`
  ADD PRIMARY KEY (`reference_id`),
  ADD UNIQUE KEY `uq_dataset_reference` (`entreprise_id`,`succursale_id`,`reference_type`,`name`),
  ADD KEY `idx_dataset_reference_scope` (`entreprise_id`,`succursale_id`,`reference_type`),
  ADD KEY `fk_dataset_reference_branch` (`succursale_id`),
  ADD KEY `fk_dataset_reference_dataset` (`jeu_donnees_id`),
  ADD KEY `fk_dataset_reference_version` (`jeu_donnees_version_id`),
  ADD KEY `idx_dataset_reference_user` (`user_id`);

--
-- Index pour la table `jeux_donnees_versions`
--
ALTER TABLE `jeux_donnees_versions`
  ADD PRIMARY KEY (`jeu_donnees_version_id`),
  ADD UNIQUE KEY `uq_jeu_donnees_version` (`jeu_donnees_id`,`version_number`),
  ADD KEY `idx_jeu_donnees_version_creator` (`created_by`);

--
-- Index pour la table `lignes_ecritures_comptables`
--
ALTER TABLE `lignes_ecritures_comptables`
  ADD PRIMARY KEY (`ligne_id`),
  ADD KEY `idx_ligne_ecriture` (`entreprise_id`,`ecriture_id`),
  ADD KEY `idx_ligne_compte` (`entreprise_id`,`compte_id`,`ecriture_id`),
  ADD KEY `fk_ligne_ecriture` (`ecriture_id`),
  ADD KEY `fk_ligne_compte` (`compte_id`);

--
-- Index pour la table `modes_paiement`
--
ALTER TABLE `modes_paiement`
  ADD PRIMARY KEY (`mode_paiement_id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Index pour la table `mouvements_caisse`
--
ALTER TABLE `mouvements_caisse`
  ADD PRIMARY KEY (`mouvement_id`),
  ADD KEY `fk_mouvement_caisse` (`caisse_id`),
  ADD KEY `fk_mouvement_user` (`user_id`),
  ADD KEY `fk_mouvement_caisse_mode` (`mode_paiement_id`),
  ADD KEY `idx_mouvement_caisse_banque` (`banque_id`,`movement_date`),
  ADD KEY `idx_mouvements_caisse_dette` (`entreprise_id`,`dette_id`,`movement_date`,`mouvement_id`);

--
-- Index pour la table `mouvements_stock`
--
ALTER TABLE `mouvements_stock`
  ADD PRIMARY KEY (`mouvement_stock_id`),
  ADD KEY `fk_mouvement_stock_succursale` (`succursale_id`),
  ADD KEY `fk_mouvement_stock_produit` (`produit_id`),
  ADD KEY `idx_mouvement_stock_ledger` (`entreprise_id`,`succursale_id`,`produit_id`,`movement_date`),
  ADD KEY `fk_mouvement_stock_user` (`user_id`);

--
-- Index pour la table `paiements_dettes_caisse`
--
ALTER TABLE `paiements_dettes_caisse`
  ADD PRIMARY KEY (`paiement_id`),
  ADD UNIQUE KEY `uq_paiements_dettes_mouvement` (`entreprise_id`,`mouvement_id`),
  ADD KEY `idx_paiements_dettes_dette` (`entreprise_id`,`dette_id`,`date_paiement`,`paiement_id`);

--
-- Index pour la table `paiements_fournisseurs`
--
ALTER TABLE `paiements_fournisseurs`
  ADD PRIMARY KEY (`paiement_id`),
  ADD KEY `fk_paiement_fournisseur_achat` (`achat_id`),
  ADD KEY `fk_paiement_fournisseur_caisse` (`caisse_id`),
  ADD KEY `idx_paiements_fournisseur_achat` (`entreprise_id`,`achat_id`),
  ADD KEY `fk_paiement_fournisseur_mode` (`mode_paiement_id`),
  ADD KEY `fk_paiement_fournisseur_banque` (`banque_id`);

--
-- Index pour la table `paiements_ventes`
--
ALTER TABLE `paiements_ventes`
  ADD PRIMARY KEY (`paiement_id`),
  ADD KEY `fk_paiement_vente_vente` (`vente_id`),
  ADD KEY `fk_paiement_vente_mode` (`mode_paiement_id`),
  ADD KEY `fk_paiement_vente_caisse` (`caisse_id`),
  ADD KEY `idx_paiements_ventes` (`entreprise_id`,`vente_id`),
  ADD KEY `fk_paiement_vente_banque` (`banque_id`);

--
-- Index pour la table `produits`
--
ALTER TABLE `produits`
  ADD PRIMARY KEY (`produit_id`),
  ADD UNIQUE KEY `uq_produit_sku` (`entreprise_id`,`sku`),
  ADD UNIQUE KEY `uq_produits_code_barre` (`entreprise_id`,`code_barre`),
  ADD KEY `fk_produit_category` (`category_id`),
  ADD KEY `fk_produit_fournisseur` (`fournisseur_id`),
  ADD KEY `idx_produits_succursale_origine` (`entreprise_id`,`succursale_origine_id`);

--
-- Index pour la table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `uq_role_name` (`entreprise_id`,`role_name`);

--
-- Index pour la table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`stock_id`),
  ADD UNIQUE KEY `uq_stock` (`entreprise_id`,`succursale_id`,`produit_id`),
  ADD KEY `fk_stock_succursale` (`succursale_id`),
  ADD KEY `fk_stock_produit` (`produit_id`);

--
-- Index pour la table `succursales`
--
ALTER TABLE `succursales`
  ADD PRIMARY KEY (`succursale_id`),
  ADD UNIQUE KEY `uq_succursale_code` (`entreprise_id`,`code`);

--
-- Index pour la table `super_admins`
--
ALTER TABLE `super_admins`
  ADD PRIMARY KEY (`super_admin_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `super_admin_notification_emails`
--
ALTER TABLE `super_admin_notification_emails`
  ADD PRIMARY KEY (`email`);

--
-- Index pour la table `super_admin_notification_settings`
--
ALTER TABLE `super_admin_notification_settings`
  ADD PRIMARY KEY (`setting_id`);

--
-- Index pour la table `taux_change`
--
ALTER TABLE `taux_change`
  ADD PRIMARY KEY (`taux_change_id`),
  ADD UNIQUE KEY `uq_taux_change_entreprise_monnaie` (`entreprise_id`,`monais`),
  ADD KEY `fk_taux_change_code` (`monais`),
  ADD KEY `fk_taux_change_user` (`updated_by`);

--
-- Index pour la table `tb_monais`
--
ALTER TABLE `tb_monais`
  ADD PRIMARY KEY (`type_monais`);

--
-- Index pour la table `transferts_stock`
--
ALTER TABLE `transferts_stock`
  ADD PRIMARY KEY (`transfert_id`),
  ADD KEY `fk_transfert_entreprise` (`entreprise_id`),
  ADD KEY `fk_transfert_produit` (`produit_id`),
  ADD KEY `fk_transfert_from` (`succursale_from_id`),
  ADD KEY `fk_transfert_to` (`succursale_to_id`);

--
-- Index pour la table `types_caisses`
--
ALTER TABLE `types_caisses`
  ADD PRIMARY KEY (`type_caisse_id`),
  ADD UNIQUE KEY `uq_type_caisse_code` (`entreprise_id`,`code`);

--
-- Index pour la table `unites_mesure`
--
ALTER TABLE `unites_mesure`
  ADD PRIMARY KEY (`unite_mesure_id`),
  ADD UNIQUE KEY `uq_unite_entreprise_name` (`entreprise_id`,`name`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uq_username` (`entreprise_id`,`username`),
  ADD KEY `fk_user_succursale` (`succursale_id`),
  ADD KEY `fk_user_role` (`role_id`);

--
-- Index pour la table `ventes`
--
ALTER TABLE `ventes`
  ADD PRIMARY KEY (`vente_id`),
  ADD UNIQUE KEY `uq_invoice` (`entreprise_id`,`invoice_no`),
  ADD KEY `fk_vente_succursale` (`succursale_id`),
  ADD KEY `fk_vente_caisse` (`caisse_id`),
  ADD KEY `fk_vente_user` (`user_id`),
  ADD KEY `fk_vente_client` (`client_id`);

--
-- Index pour la table `vente_details`
--
ALTER TABLE `vente_details`
  ADD PRIMARY KEY (`vente_detail_id`),
  ADD KEY `fk_vente_detail_entreprise` (`entreprise_id`),
  ADD KEY `fk_vente_detail_vente` (`vente_id`),
  ADD KEY `fk_vente_detail_produit` (`produit_id`);

--
-- Index pour la table `vente_detail_lots`
--
ALTER TABLE `vente_detail_lots`
  ADD PRIMARY KEY (`vente_detail_lot_id`),
  ADD KEY `fk_vente_lot_detail` (`vente_detail_id`),
  ADD KEY `fk_vente_lot_achat_detail` (`achat_detail_id`),
  ADD KEY `idx_vente_detail_lots` (`entreprise_id`,`vente_detail_id`);

--
-- Index pour la table `vente_service_details`
--
ALTER TABLE `vente_service_details`
  ADD PRIMARY KEY (`vente_service_detail_id`),
  ADD KEY `fk_vente_service_detail_vente` (`vente_id`),
  ADD KEY `idx_vente_service_details_vente` (`entreprise_id`,`vente_id`);

--
-- Index pour la table `vente_totaux_monnaies`
--
ALTER TABLE `vente_totaux_monnaies`
  ADD PRIMARY KEY (`entreprise_id`,`vente_id`,`monais`),
  ADD KEY `idx_vente_totaux_monnaies` (`entreprise_id`,`monais`),
  ADD KEY `fk_vente_totaux_vente` (`vente_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `achats`
--
ALTER TABLE `achats`
  MODIFY `achat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT pour la table `achat_details`
--
ALTER TABLE `achat_details`
  MODIFY `achat_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT pour la table `achat_detail_sorties`
--
ALTER TABLE `achat_detail_sorties`
  MODIFY `sortie_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `banques`
--
ALTER TABLE `banques`
  MODIFY `banque_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `bons_commande_previsionnels`
--
ALTER TABLE `bons_commande_previsionnels`
  MODIFY `bon_previsionnel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `bon_commande_previsionnel_details`
--
ALTER TABLE `bon_commande_previsionnel_details`
  MODIFY `detail_previsionnel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `caisse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `clients`
--
ALTER TABLE `clients`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `comptes_comptables`
--
ALTER TABLE `comptes_comptables`
  MODIFY `compte_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `demandes_annulation_ecritures`
--
ALTER TABLE `demandes_annulation_ecritures`
  MODIFY `demande_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `demandes_annulation_mouvements_caisse`
--
ALTER TABLE `demandes_annulation_mouvements_caisse`
  MODIFY `demande_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `dettes_caisse`
--
ALTER TABLE `dettes_caisse`
  MODIFY `dette_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `ecritures_comptables`
--
ALTER TABLE `ecritures_comptables`
  MODIFY `ecriture_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `entreprises`
--
ALTER TABLE `entreprises`
  MODIFY `entreprise_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `fournisseurs`
--
ALTER TABLE `fournisseurs`
  MODIFY `fournisseur_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `jeux_donnees`
--
ALTER TABLE `jeux_donnees`
  MODIFY `jeu_donnees_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `jeux_donnees_importations`
--
ALTER TABLE `jeux_donnees_importations`
  MODIFY `importation_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `jeux_donnees_references`
--
ALTER TABLE `jeux_donnees_references`
  MODIFY `reference_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `jeux_donnees_versions`
--
ALTER TABLE `jeux_donnees_versions`
  MODIFY `jeu_donnees_version_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `lignes_ecritures_comptables`
--
ALTER TABLE `lignes_ecritures_comptables`
  MODIFY `ligne_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `modes_paiement`
--
ALTER TABLE `modes_paiement`
  MODIFY `mode_paiement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `mouvements_caisse`
--
ALTER TABLE `mouvements_caisse`
  MODIFY `mouvement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT pour la table `mouvements_stock`
--
ALTER TABLE `mouvements_stock`
  MODIFY `mouvement_stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT pour la table `paiements_dettes_caisse`
--
ALTER TABLE `paiements_dettes_caisse`
  MODIFY `paiement_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `paiements_fournisseurs`
--
ALTER TABLE `paiements_fournisseurs`
  MODIFY `paiement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `paiements_ventes`
--
ALTER TABLE `paiements_ventes`
  MODIFY `paiement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `produit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pour la table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT pour la table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT pour la table `succursales`
--
ALTER TABLE `succursales`
  MODIFY `succursale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `super_admins`
--
ALTER TABLE `super_admins`
  MODIFY `super_admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `taux_change`
--
ALTER TABLE `taux_change`
  MODIFY `taux_change_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `transferts_stock`
--
ALTER TABLE `transferts_stock`
  MODIFY `transfert_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `types_caisses`
--
ALTER TABLE `types_caisses`
  MODIFY `type_caisse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT pour la table `unites_mesure`
--
ALTER TABLE `unites_mesure`
  MODIFY `unite_mesure_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT pour la table `ventes`
--
ALTER TABLE `ventes`
  MODIFY `vente_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT pour la table `vente_details`
--
ALTER TABLE `vente_details`
  MODIFY `vente_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT pour la table `vente_detail_lots`
--
ALTER TABLE `vente_detail_lots`
  MODIFY `vente_detail_lot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `vente_service_details`
--
ALTER TABLE `vente_service_details`
  MODIFY `vente_service_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `achats`
--
ALTER TABLE `achats`
  ADD CONSTRAINT `fk_achat_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_achat_fournisseur` FOREIGN KEY (`fournisseur_id`) REFERENCES `fournisseurs` (`fournisseur_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_achat_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_achat_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `achat_details`
--
ALTER TABLE `achat_details`
  ADD CONSTRAINT `fk_achat_detail_achat` FOREIGN KEY (`achat_id`) REFERENCES `achats` (`achat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_achat_detail_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_achat_detail_produit` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`produit_id`);

--
-- Contraintes pour la table `achat_detail_sorties`
--
ALTER TABLE `achat_detail_sorties`
  ADD CONSTRAINT `fk_sortie_detail_achat_detail` FOREIGN KEY (`sortie_detail_id`) REFERENCES `achat_details` (`achat_detail_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sortie_detail_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sortie_detail_lot` FOREIGN KEY (`lot_detail_id`) REFERENCES `achat_details` (`achat_detail_id`);

--
-- Contraintes pour la table `banques`
--
ALTER TABLE `banques`
  ADD CONSTRAINT `fk_banque_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `bons_commande_previsionnels`
--
ALTER TABLE `bons_commande_previsionnels`
  ADD CONSTRAINT `fk_bon_previsionnel_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_bon_previsionnel_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_bon_previsionnel_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Contraintes pour la table `bon_commande_previsionnel_details`
--
ALTER TABLE `bon_commande_previsionnel_details`
  ADD CONSTRAINT `fk_bon_previsionnel_detail_bon` FOREIGN KEY (`bon_previsionnel_id`) REFERENCES `bons_commande_previsionnels` (`bon_previsionnel_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_bon_previsionnel_detail_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_bon_previsionnel_detail_fournisseur` FOREIGN KEY (`fournisseur_id`) REFERENCES `fournisseurs` (`fournisseur_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_bon_previsionnel_detail_produit` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`produit_id`);

--
-- Contraintes pour la table `caisses`
--
ALTER TABLE `caisses`
  ADD CONSTRAINT `fk_caisse_banque` FOREIGN KEY (`banque_id`) REFERENCES `banques` (`banque_id`),
  ADD CONSTRAINT `fk_caisse_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_caisse_mode_paiement` FOREIGN KEY (`mode_paiement_id`) REFERENCES `modes_paiement` (`mode_paiement_id`),
  ADD CONSTRAINT `fk_caisse_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_caisse_type` FOREIGN KEY (`type_caisse_id`) REFERENCES `types_caisses` (`type_caisse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_caisse_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_category_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `fk_client_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `comptes_comptables`
--
ALTER TABLE `comptes_comptables`
  ADD CONSTRAINT `fk_compte_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_compte_parent` FOREIGN KEY (`parent_id`) REFERENCES `comptes_comptables` (`compte_id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `demandes_annulation_ecritures`
--
ALTER TABLE `demandes_annulation_ecritures`
  ADD CONSTRAINT `fk_demande_annulation_decisionnaire` FOREIGN KEY (`decision_par`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_demande_annulation_demandeur` FOREIGN KEY (`demandeur_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_demande_annulation_ecriture` FOREIGN KEY (`ecriture_id`) REFERENCES `ecritures_comptables` (`ecriture_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_demande_annulation_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `demandes_annulation_mouvements_caisse`
--
ALTER TABLE `demandes_annulation_mouvements_caisse`
  ADD CONSTRAINT `fk_demande_caisse_compensation` FOREIGN KEY (`mouvement_compensation_id`) REFERENCES `mouvements_caisse` (`mouvement_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_demande_caisse_decisionnaire` FOREIGN KEY (`decision_par`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_demande_caisse_demandeur` FOREIGN KEY (`demandeur_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_demande_caisse_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_demande_caisse_mouvement` FOREIGN KEY (`mouvement_id`) REFERENCES `mouvements_caisse` (`mouvement_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `ecritures_comptables`
--
ALTER TABLE `ecritures_comptables`
  ADD CONSTRAINT `fk_ecriture_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ecriture_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `entreprise_droits_modules`
--
ALTER TABLE `entreprise_droits_modules`
  ADD CONSTRAINT `fk_droits_modules_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `entreprise_monnaie_reference`
--
ALTER TABLE `entreprise_monnaie_reference`
  ADD CONSTRAINT `fk_monnaie_reference_code` FOREIGN KEY (`monais`) REFERENCES `tb_monais` (`type_monais`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_monnaie_reference_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `fournisseurs`
--
ALTER TABLE `fournisseurs`
  ADD CONSTRAINT `fk_fournisseur_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_fournisseur_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `jeux_donnees_importations`
--
ALTER TABLE `jeux_donnees_importations`
  ADD CONSTRAINT `fk_jeu_import_dataset` FOREIGN KEY (`jeu_donnees_id`) REFERENCES `jeux_donnees` (`jeu_donnees_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_jeu_import_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_jeu_import_version` FOREIGN KEY (`jeu_donnees_version_id`) REFERENCES `jeux_donnees_versions` (`jeu_donnees_version_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `jeux_donnees_references`
--
ALTER TABLE `jeux_donnees_references`
  ADD CONSTRAINT `fk_dataset_reference_branch` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dataset_reference_dataset` FOREIGN KEY (`jeu_donnees_id`) REFERENCES `jeux_donnees` (`jeu_donnees_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dataset_reference_enterprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dataset_reference_version` FOREIGN KEY (`jeu_donnees_version_id`) REFERENCES `jeux_donnees_versions` (`jeu_donnees_version_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `jeux_donnees_versions`
--
ALTER TABLE `jeux_donnees_versions`
  ADD CONSTRAINT `fk_jeu_donnees_version_parent` FOREIGN KEY (`jeu_donnees_id`) REFERENCES `jeux_donnees` (`jeu_donnees_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `lignes_ecritures_comptables`
--
ALTER TABLE `lignes_ecritures_comptables`
  ADD CONSTRAINT `fk_ligne_compte` FOREIGN KEY (`compte_id`) REFERENCES `comptes_comptables` (`compte_id`),
  ADD CONSTRAINT `fk_ligne_ecriture` FOREIGN KEY (`ecriture_id`) REFERENCES `ecritures_comptables` (`ecriture_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ligne_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `mouvements_caisse`
--
ALTER TABLE `mouvements_caisse`
  ADD CONSTRAINT `fk_mouvement_caisse` FOREIGN KEY (`caisse_id`) REFERENCES `caisses` (`caisse_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mouvement_caisse_banque` FOREIGN KEY (`banque_id`) REFERENCES `banques` (`banque_id`),
  ADD CONSTRAINT `fk_mouvement_caisse_mode` FOREIGN KEY (`mode_paiement_id`) REFERENCES `modes_paiement` (`mode_paiement_id`),
  ADD CONSTRAINT `fk_mouvement_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mouvement_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `mouvements_stock`
--
ALTER TABLE `mouvements_stock`
  ADD CONSTRAINT `fk_mouvement_stock_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mouvement_stock_produit` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`produit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mouvement_stock_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mouvement_stock_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `paiements_fournisseurs`
--
ALTER TABLE `paiements_fournisseurs`
  ADD CONSTRAINT `fk_paiement_fournisseur_achat` FOREIGN KEY (`achat_id`) REFERENCES `achats` (`achat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_paiement_fournisseur_banque` FOREIGN KEY (`banque_id`) REFERENCES `banques` (`banque_id`),
  ADD CONSTRAINT `fk_paiement_fournisseur_caisse` FOREIGN KEY (`caisse_id`) REFERENCES `caisses` (`caisse_id`),
  ADD CONSTRAINT `fk_paiement_fournisseur_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_paiement_fournisseur_mode` FOREIGN KEY (`mode_paiement_id`) REFERENCES `modes_paiement` (`mode_paiement_id`);

--
-- Contraintes pour la table `paiements_ventes`
--
ALTER TABLE `paiements_ventes`
  ADD CONSTRAINT `fk_paiement_vente_banque` FOREIGN KEY (`banque_id`) REFERENCES `banques` (`banque_id`),
  ADD CONSTRAINT `fk_paiement_vente_caisse` FOREIGN KEY (`caisse_id`) REFERENCES `caisses` (`caisse_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_paiement_vente_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_paiement_vente_mode` FOREIGN KEY (`mode_paiement_id`) REFERENCES `modes_paiement` (`mode_paiement_id`),
  ADD CONSTRAINT `fk_paiement_vente_vente` FOREIGN KEY (`vente_id`) REFERENCES `ventes` (`vente_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `produits`
--
ALTER TABLE `produits`
  ADD CONSTRAINT `fk_produit_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_produit_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_produit_fournisseur` FOREIGN KEY (`fournisseur_id`) REFERENCES `fournisseurs` (`fournisseur_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `fk_role_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `fk_stock_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_produit` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`produit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `succursales`
--
ALTER TABLE `succursales`
  ADD CONSTRAINT `fk_succursale_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `taux_change`
--
ALTER TABLE `taux_change`
  ADD CONSTRAINT `fk_taux_change_code` FOREIGN KEY (`monais`) REFERENCES `tb_monais` (`type_monais`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_taux_change_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_taux_change_user` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `transferts_stock`
--
ALTER TABLE `transferts_stock`
  ADD CONSTRAINT `fk_transfert_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transfert_from` FOREIGN KEY (`succursale_from_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transfert_produit` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`produit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transfert_to` FOREIGN KEY (`succursale_to_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `types_caisses`
--
ALTER TABLE `types_caisses`
  ADD CONSTRAINT `fk_type_caisse_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `unites_mesure`
--
ALTER TABLE `unites_mesure`
  ADD CONSTRAINT `fk_unite_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `ventes`
--
ALTER TABLE `ventes`
  ADD CONSTRAINT `fk_vente_caisse` FOREIGN KEY (`caisse_id`) REFERENCES `caisses` (`caisse_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vente_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vente_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vente_succursale` FOREIGN KEY (`succursale_id`) REFERENCES `succursales` (`succursale_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vente_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `vente_details`
--
ALTER TABLE `vente_details`
  ADD CONSTRAINT `fk_vente_detail_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vente_detail_produit` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`produit_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vente_detail_vente` FOREIGN KEY (`vente_id`) REFERENCES `ventes` (`vente_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `vente_detail_lots`
--
ALTER TABLE `vente_detail_lots`
  ADD CONSTRAINT `fk_vente_lot_achat_detail` FOREIGN KEY (`achat_detail_id`) REFERENCES `achat_details` (`achat_detail_id`),
  ADD CONSTRAINT `fk_vente_lot_detail` FOREIGN KEY (`vente_detail_id`) REFERENCES `vente_details` (`vente_detail_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_vente_lot_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `vente_service_details`
--
ALTER TABLE `vente_service_details`
  ADD CONSTRAINT `fk_vente_service_detail_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_vente_service_detail_vente` FOREIGN KEY (`vente_id`) REFERENCES `ventes` (`vente_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `vente_totaux_monnaies`
--
ALTER TABLE `vente_totaux_monnaies`
  ADD CONSTRAINT `fk_vente_totaux_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_vente_totaux_vente` FOREIGN KEY (`vente_id`) REFERENCES `ventes` (`vente_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
