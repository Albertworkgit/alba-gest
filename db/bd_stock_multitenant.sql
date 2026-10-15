-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 12 oct. 2026 à 11:21
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
(46, 7, 6, 3, 10, '097', '2026-09-30 11:34:21', '2026-09-30 11:34:21', 1000.00, 1000.00, 'USD', 'IN', '', 'RECEIVED', '2026-09-30 09:34:21'),
(47, 7, 6, 3, 10, '121', '2026-09-30 11:59:51', NULL, 100.00, 0.00, 'USD', 'IN', '', 'CANCELLED', '2026-09-30 09:59:51'),
(48, 7, 6, 3, 10, '1213', '2026-09-30 12:06:03', '2026-09-30 12:06:03', 100.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-09-30 10:06:03'),
(49, 7, 6, NULL, 10, 'Aq', '2026-09-30 13:34:29', '2026-09-30 13:34:29', 100000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-09-30 11:34:29'),
(50, 7, 6, NULL, 10, '1', '2026-10-01 19:45:57', '2026-10-01 19:55:31', 1000.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-01 17:45:57'),
(51, 7, 6, 4, 10, '1d5g', '2026-10-06 10:57:30', '2026-10-06 10:58:16', 500.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-06 08:57:30'),
(52, 7, 6, 6, 10, 'Fugp', '2026-10-08 11:46:01', '2026-10-08 11:46:01', 600.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-08 09:46:01'),
(53, 9, 8, 8, 13, 'Zadd', '2026-10-09 16:57:59', '2026-10-09 16:57:59', 20000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-10-09 14:57:59'),
(54, 9, 8, 8, 13, 'R5g', '2026-10-09 17:02:36', '2026-10-09 17:02:36', 150000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-10-09 15:02:36'),
(55, 9, 8, NULL, 13, 'F', '2026-10-09 17:08:35', '2026-10-09 17:08:35', 0.00, 0.00, NULL, 'OUT', 'Expiration', 'RECEIVED', '2026-10-09 15:08:35'),
(56, 7, 6, NULL, 10, 'Re', '2026-10-10 15:53:23', '2026-10-10 15:53:23', 1000000.00, 0.00, 'CDF', 'IN', '', 'RECEIVED', '2026-10-10 13:53:23'),
(57, 8, 7, 9, 12, '1d5g', '2026-10-11 10:47:53', '2026-10-11 10:47:53', 250.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-11 08:47:53'),
(58, 8, 7, 9, 12, 'Tug', '2026-10-11 10:49:14', '2026-10-11 10:49:31', 100.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-11 08:49:14'),
(59, 7, 6, NULL, 10, 'HJK', '2026-10-11 13:22:16', '2026-10-11 13:22:16', 0.00, 0.00, NULL, 'OUT', 'Sortie en stock', 'RECEIVED', '2026-10-11 11:22:16'),
(60, 7, 6, NULL, 10, 'J', '2026-10-11 13:24:07', '2026-10-11 13:24:07', 0.00, 0.00, NULL, 'OUT', 'EXXX', 'RECEIVED', '2026-10-11 11:24:07');

-- --------------------------------------------------------

--
-- Structure de la table `achat_details`
--

CREATE TABLE `achat_details` (
  `achat_detail_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `achat_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `date_expiration` date DEFAULT NULL,
  `quantity_out` int(11) NOT NULL DEFAULT 0,
  `unit_cost` decimal(15,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `achat_details`
--

INSERT INTO `achat_details` (`achat_detail_id`, `entreprise_id`, `achat_id`, `produit_id`, `quantity`, `date_expiration`, `quantity_out`, `unit_cost`, `subtotal`, `created_at`) VALUES
(25, 7, 46, 7, 10, NULL, 0, 100.00, 1000.00, '2026-09-30 09:34:21'),
(26, 7, 47, 8, 100, NULL, 0, 1.00, 100.00, '2026-09-30 09:59:51'),
(27, 7, 48, 8, 100, NULL, 0, 1.00, 100.00, '2026-09-30 10:06:03'),
(28, 7, 49, 9, 100, NULL, 0, 1000.00, 100000.00, '2026-09-30 11:34:29'),
(29, 7, 50, 7, 10, NULL, 0, 100.00, 1000.00, '2026-10-01 17:45:57'),
(30, 7, 51, 10, 50, '2026-10-09', 27, 10.00, 500.00, '2026-10-06 08:57:30'),
(31, 7, 52, 11, 60, '2026-10-11', 20, 10.00, 600.00, '2026-10-08 09:46:02'),
(32, 9, 53, 13, 20, '2026-10-12', 8, 1000.00, 20000.00, '2026-10-09 14:57:59'),
(33, 9, 54, 12, 50, NULL, 0, 3000.00, 150000.00, '2026-10-09 15:02:36'),
(34, 9, 55, 13, 5, NULL, 0, 0.00, 0.00, '2026-10-09 15:08:35'),
(35, 7, 56, 14, 1000, NULL, 0, 1000.00, 1000000.00, '2026-10-10 13:53:23'),
(36, 8, 57, 15, 50, '2026-10-14', 17, 5.00, 250.00, '2026-10-11 08:47:53'),
(37, 8, 58, 15, 20, '2026-12-31', 0, 5.00, 100.00, '2026-10-11 08:49:16'),
(38, 7, 59, 10, 3, NULL, 0, 0.00, 0.00, '2026-10-11 11:22:16'),
(39, 7, 60, 10, 10, NULL, 0, 0.00, 0.00, '2026-10-11 11:24:07');

-- --------------------------------------------------------

--
-- Structure de la table `achat_detail_sorties`
--

CREATE TABLE `achat_detail_sorties` (
  `sortie_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `sortie_detail_id` int(11) NOT NULL,
  `lot_detail_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `achat_detail_sorties`
--

INSERT INTO `achat_detail_sorties` (`sortie_id`, `entreprise_id`, `sortie_detail_id`, `lot_detail_id`, `quantity`, `created_at`) VALUES
(6, 9, 34, 32, 5, '2026-10-09 15:08:35'),
(7, 7, 38, 30, 3, '2026-10-11 11:22:16'),
(8, 7, 39, 30, 10, '2026-10-11 11:24:07');

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
(2, 7, 'CADECO', '97765', 1, '2026-09-30 16:53:12');

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
(7, 7, 6, 10, 1, NULL, 10, 'Caise $', '2026-09-30 11:38:04', NULL, 0.00, 2282.17, 0.00, 'OUVERTE', '2026-09-30 09:38:04'),
(8, 7, 6, 11, 1, NULL, 10, 'Caisse Fc', '2026-09-30 15:25:56', NULL, 0.00, 95509.00, 0.00, 'OUVERTE', '2026-09-30 13:25:56'),
(9, 7, 6, 10, 3, 2, 10, 'CAISSE BANQUE', '2026-09-30 18:53:54', NULL, 0.00, 5.00, 0.00, 'OUVERTE', '2026-09-30 16:53:54'),
(10, 7, 6, 10, 2, NULL, 10, 'MOBILE MONEY', '2026-09-30 18:55:45', NULL, 0.00, 505.00, 0.00, 'OUVERTE', '2026-09-30 16:55:45'),
(11, 9, 8, 14, 1, NULL, 13, 'Caisse fc', '2026-10-09 17:23:22', NULL, 0.00, 168000.00, 0.00, 'OUVERTE', '2026-10-09 15:23:22'),
(12, 8, 7, 15, 1, NULL, 12, 'Caisse $', '2026-10-11 10:54:53', NULL, 0.00, 0.00, 0.00, 'OUVERTE', '2026-10-11 08:54:53'),
(13, 8, 7, 16, 1, NULL, 12, 'Caisse fc', '2026-10-11 10:55:04', NULL, 0.00, 0.00, 0.00, 'OUVERTE', '2026-10-11 08:55:04');

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
(6, 7, 'PC', 'Ordinateur '),
(7, 7, 'Service ', ''),
(8, 7, 'Comprime', ''),
(10, 9, 'Aliment', 'Les aliments '),
(11, 8, 'Aliment', ''),
(12, 8, 'Gel', '');

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

CREATE TABLE `clients` (
  `client_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `clients`
--

INSERT INTO `clients` (`client_id`, `entreprise_id`, `name`, `email`, `phone`, `address`, `created_at`) VALUES
(3, 7, 'OSCAR BCZ', 'oscar@gmail.com', '', '', '2026-09-30 10:27:23'),
(4, 7, 'Alberson', '', '', '', '2026-10-01 17:49:44'),
(5, 7, 'IT KATOLO', '', '', '', '2026-10-03 14:15:56'),
(6, 7, 'IT KATOLO', '', '', '', '2026-10-03 14:15:56'),
(7, 7, 'Agis kinga', '', '', '', '2026-10-06 09:05:52');

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

--
-- Déchargement des données de la table `comptes_comptables`
--

INSERT INTO `comptes_comptables` (`compte_id`, `entreprise_id`, `code`, `intitule`, `classe`, `nature`, `parent_id`, `is_system`, `is_active`, `created_at`) VALUES
(3, 7, 'TRS', 'tresorerie', 5, 'CREDIT', NULL, 0, 1, '2026-10-01 15:57:17'),
(4, 7, '1110', 'FOURNISSEUR', 3, 'DEBIT', 3, 0, 0, '2026-10-01 15:58:14'),
(5, 7, '570', 'Caisse', 5, 'DEBIT', NULL, 0, 1, '2026-10-05 10:19:54'),
(6, 7, '571', 'Caisse principale', 5, 'DEBIT', 5, 0, 1, '2026-10-05 10:20:53'),
(7, 7, '40', 'Fournisseur', 4, 'CREDIT', NULL, 0, 1, '2026-10-05 10:23:28'),
(8, 7, '401', 'Fournisseur général', 4, 'CREDIT', 7, 0, 1, '2026-10-05 10:24:08'),
(9, 7, '410', 'Client', 4, 'DEBIT', NULL, 0, 1, '2026-10-05 10:25:07'),
(10, 7, '411', 'Client général', 1, 'DEBIT', 9, 0, 1, '2026-10-05 10:26:01'),
(11, 7, '60', 'Achat', 6, 'DEBIT', NULL, 0, 1, '2026-10-05 10:29:29'),
(12, 7, '601', 'Achats marchandises', 6, 'DEBIT', 11, 0, 1, '2026-10-05 10:30:31'),
(13, 7, '52', 'Tmb', 5, 'DEBIT', NULL, 0, 1, '2026-10-08 09:22:50');

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

--
-- Déchargement des données de la table `demandes_annulation_ecritures`
--

INSERT INTO `demandes_annulation_ecritures` (`demande_id`, `entreprise_id`, `ecriture_id`, `demandeur_id`, `motif`, `statut`, `decision_par`, `motif_decision`, `created_at`, `decision_at`) VALUES
(1, 7, 2, 10, 'Je veux bien corriger', 'REFUSEE', 10, '', '2026-10-05 11:31:40', '2026-10-05 13:32:27'),
(2, 7, 2, 10, 'Je veux bien', 'APPROUVEE', 10, '', '2026-10-05 11:32:40', '2026-10-05 13:32:44'),
(3, 7, 3, 11, 'JE VEUT ANNULER TOUJOUR', 'REFUSEE', 10, '', '2026-10-05 11:37:15', '2026-10-05 13:45:29'),
(4, 7, 3, 11, 'JJJ', 'REFUSEE', 10, '', '2026-10-05 11:46:09', '2026-10-05 13:46:58'),
(5, 7, 6, 10, 'Fuo', 'REFUSEE', 10, '', '2026-10-08 09:31:32', '2026-10-08 11:31:58');

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

--
-- Déchargement des données de la table `demandes_annulation_mouvements_caisse`
--

INSERT INTO `demandes_annulation_mouvements_caisse` (`demande_id`, `entreprise_id`, `mouvement_id`, `demandeur_id`, `motif`, `statut`, `decision_par`, `motif_decision`, `mouvement_compensation_id`, `created_at`, `decision_at`) VALUES
(1, 7, 29, 10, 'Tui', 'REFUSEE', 10, '', NULL, '2026-10-05 12:14:48', '2026-10-05 14:15:44');

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

--
-- Déchargement des données de la table `ecritures_comptables`
--

INSERT INTO `ecritures_comptables` (`ecriture_id`, `entreprise_id`, `date_ecriture`, `journal_code`, `reference`, `libelle`, `monnaie`, `source_type`, `source_id`, `statut`, `user_id`, `created_at`) VALUES
(2, 7, '2026-10-01', 'UUG', 'Ty', 'Ztt', 'USD', NULL, NULL, 'ANNULEE', 10, '2026-10-01 18:00:16'),
(3, 7, '2026-10-05', 'VENTE', '1783', 'Achat', 'USD', NULL, NULL, 'VALIDEE', 10, '2026-10-05 10:33:11'),
(4, 7, '2026-10-05', 'OD', '1783f', 'Achat produit', 'USD', NULL, NULL, 'VALIDEE', 10, '2026-10-05 16:37:43'),
(5, 7, '2026-10-05', 'ODHIJH', '1783fhj', 'Achat produit f', 'USD', NULL, NULL, 'VALIDEE', 10, '2026-10-05 17:01:41'),
(6, 7, '2026-10-08', 'OD', '1783f', 'Paiement facture n', 'USD', NULL, NULL, 'VALIDEE', 10, '2026-10-08 09:30:29');

-- --------------------------------------------------------

--
-- Structure de la table `entreprises`
--

CREATE TABLE `entreprises` (
  `entreprise_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Nom de l entreprise',
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `rccm` varchar(100) DEFAULT NULL,
  `boite_postale` varchar(100) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `cachet` varchar(255) DEFAULT NULL,
  `max_succursales` int(11) NOT NULL DEFAULT 2,
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=active, 0=desactivee',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `entreprises`
--

INSERT INTO `entreprises` (`entreprise_id`, `name`, `email`, `phone`, `address`, `rccm`, `boite_postale`, `logo`, `cachet`, `max_succursales`, `is_active`, `created_at`) VALUES
(7, 'ALBERT TECHNOLOGIE', 'alberttech@gmail.com', '0981326086', 'Province Du Nord Kivu/République Démocratique du Congo', '', '', 'backend/uploads/companies/7/logo-bc24085a12aabd94b8cfd9f170076de6.png', 'backend/uploads/companies/7/stamp-d6fb1316e8c005da506ae71b52990949.png', 2, 1, '2026-09-30 09:26:41'),
(8, 'Bcz', 'abiba@gmail.com', '0967289836', 'Musien Hopital', NULL, NULL, NULL, NULL, 2, 1, '2026-10-08 14:56:23'),
(9, 'ALIMENTATION SALAMA', 'ojcd@gmail.com', '0967289836', 'Oïcha Moba', NULL, NULL, NULL, NULL, 2, 1, '2026-10-09 14:28:41');

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
(7, '[\"stock\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-09-30 10:23:56'),
(8, '[\"stock\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-10-08 15:02:39'),
(9, '[\"stock\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-10-09 14:30:37');

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
(7, 'CDF', '2026-10-10 15:42:29');

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
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `fournisseurs`
--

INSERT INTO `fournisseurs` (`fournisseur_id`, `entreprise_id`, `succursale_id`, `name`, `contact_name`, `email`, `phone`, `address`) VALUES
(3, 7, NULL, 'Fabrice ', '098876542', 'sambu@gmail.com', '9865322224', ''),
(4, 7, NULL, 'Albert', 'Musien Hopital', 'musienhopital@gmail.com', '', ''),
(6, 7, NULL, 'ASRMES', '', '', '', ''),
(8, 9, NULL, 'Alberto', '', '', '', ''),
(9, 8, NULL, 'Palos', '', '', '', '');

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

--
-- Déchargement des données de la table `lignes_ecritures_comptables`
--

INSERT INTO `lignes_ecritures_comptables` (`ligne_id`, `entreprise_id`, `ecriture_id`, `compte_id`, `libelle`, `debit`, `credit`, `created_at`) VALUES
(3, 7, 2, 3, 'Jui', 0.00, 100.00, '2026-10-01 18:00:17'),
(4, 7, 2, 4, 'Hhuu', 100.00, 0.00, '2026-10-01 18:00:17'),
(5, 7, 3, 12, 'Achat marchandises un', 100.00, 0.00, '2026-10-05 10:33:11'),
(6, 7, 3, 8, 'Paiement fournisseurs', 0.00, 100.00, '2026-10-05 10:33:11'),
(7, 7, 4, 8, 'Achat marchanises un', 150.00, 0.00, '2026-10-05 16:37:44'),
(8, 7, 4, 6, 'Achat marchanises un', 0.00, 150.00, '2026-10-05 16:37:44'),
(11, 7, 5, 8, 'Achat marchises un', 20.00, 0.00, '2026-10-05 17:05:57'),
(12, 7, 5, 6, 'Achat mchanises un', 0.00, 20.00, '2026-10-05 17:05:57'),
(13, 7, 6, 9, 'Paiement facture n', 0.00, 150.00, '2026-10-08 09:30:29'),
(14, 7, 6, 13, 'Paiement facture n', 150.00, 0.00, '2026-10-08 09:30:29');

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
  `movement_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `mouvements_caisse`
--

INSERT INTO `mouvements_caisse` (`mouvement_id`, `entreprise_id`, `caisse_id`, `user_id`, `mode_paiement_id`, `banque_id`, `bank_reference`, `type`, `amount`, `reason`, `reference_id`, `movement_date`) VALUES
(15, 7, 7, 10, 1, NULL, '', 'ENTREE', 1500.00, 'Paiement vente FAC-20260930-1LAN', 10, '2026-09-30 15:24:43'),
(16, 7, 8, 10, 1, NULL, '', 'ENTREE', 12500.00, 'Paiement vente FAC-20260930-1LAN', 10, '2026-09-30 15:26:45'),
(17, 7, 7, 10, 1, NULL, '', 'ENTREE', 745.00, 'Paiement vente FAC-20260930-F98Q', 8, '2026-09-30 15:31:09'),
(18, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20260930-LGMV', 9, '2026-09-30 15:31:15'),
(19, 7, 7, 10, 1, NULL, '', 'SORTIE', 1000.00, 'Paiement fournisseur Fabrice  · 097', 46, '2026-09-30 15:46:34'),
(20, 7, 9, 10, 3, 2, 'HHHH', 'ENTREE', 5.00, 'Paiement vente FAC-20260930-J2QY', 11, '2026-09-30 18:54:36'),
(21, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20260930-J2QY', 11, '2026-09-30 18:55:10'),
(22, 7, 10, 10, 2, NULL, 'HHHH', 'ENTREE', 5.00, 'Paiement vente FAC-20260930-J2QY', 11, '2026-09-30 18:56:28'),
(23, 7, 8, 10, 1, NULL, '', 'ENTREE', 37500.00, 'Paiement vente FAC-20260930-J2QY', 11, '2026-09-30 18:56:39'),
(27, 7, 7, 10, 1, NULL, '', 'ENTREE', 120.00, 'Paiement vente FAC-20261001-77ZF', 12, '2026-10-01 19:51:01'),
(28, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20261005-CXXA', 15, '2026-10-05 14:13:56'),
(29, 7, 10, 10, 2, NULL, NULL, 'ENTREE', 500.00, 'Autre financement', NULL, '2026-10-05 14:14:34'),
(30, 7, 7, 10, 1, NULL, '', 'ENTREE', 200.00, 'Paiement vente FAC-20261008-XMCJ', 17, '2026-10-08 12:06:56'),
(31, 9, 11, 13, 1, NULL, '', 'ENTREE', 50000.00, 'Paiement vente FAC-20261009-MH0F', 18, '2026-10-09 17:29:38'),
(32, 9, 11, 13, 1, NULL, '', 'ENTREE', 10000.00, 'Paiement vente FAC-20261009-MH0F', 18, '2026-10-09 17:30:58'),
(33, 9, 11, 13, 1, NULL, '', 'ENTREE', 8000.00, 'Paiement vente FAC-20261009-MH0F', 18, '2026-10-09 17:31:58'),
(34, 9, 11, 13, 1, NULL, NULL, 'ENTREE', 100000.00, 'Renforcement capital', NULL, '2026-10-09 17:34:28'),
(35, 7, 7, 10, 1, NULL, '', 'ENTREE', 10.00, 'Paiement vente FAC-20261010-YB7D', 19, '2026-10-10 17:10:58'),
(36, 7, 8, 10, 1, NULL, '', 'ENTREE', 7000.00, 'Paiement vente FAC-20261010-YB7D', 19, '2026-10-10 17:12:34'),
(37, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20261010-YB7D', 19, '2026-10-10 17:59:27'),
(38, 7, 7, 10, 1, NULL, '', 'ENTREE', 10.00, 'Paiement vente FAC-20261010-P6IG', 20, '2026-10-10 17:59:53'),
(39, 7, 8, 10, 1, NULL, '', 'ENTREE', 27000.00, 'Paiement vente FAC-20261010-P6IG', 20, '2026-10-10 18:00:03'),
(40, 7, 8, 10, 1, NULL, '', 'ENTREE', 11500.00, 'Paiement vente FAC-20261010-P6IG', 20, '2026-10-10 18:04:42'),
(41, 7, 7, 10, 1, NULL, '', 'ENTREE', 2.17, 'Paiement vente FAC-20261010-XWWI', 21, '2026-10-10 18:05:17'),
(42, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20261003-BZW5', 13, '2026-10-11 01:24:29'),
(43, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20261003-YI1O', 14, '2026-10-11 01:24:34'),
(44, 7, 7, 10, 1, NULL, '', 'ENTREE', 580.00, 'Paiement vente FAC-20261006-JWTA', 16, '2026-10-11 01:24:37'),
(45, 7, 8, 10, 1, NULL, '', 'ENTREE', 9.00, 'Paiement vente FAC-20261010-XWWI', 21, '2026-10-11 01:25:13'),
(46, 7, 7, 10, 1, NULL, '', 'ENTREE', 5.00, 'Paiement vente FAC-20261010-XWWI', 21, '2026-10-11 01:25:18'),
(47, 7, 7, 10, 1, NULL, '', 'ENTREE', 80.00, 'Paiement vente FAC-20261008-XMCJ', 17, '2026-10-11 01:25:45');

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
  `quantity_before` int(11) NOT NULL,
  `quantity_moved` int(11) NOT NULL DEFAULT 0,
  `quantity_after` int(11) NOT NULL,
  `reference_type` varchar(30) NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `movement_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `mouvements_stock`
--

INSERT INTO `mouvements_stock` (`mouvement_stock_id`, `entreprise_id`, `succursale_id`, `produit_id`, `user_id`, `movement_type`, `quantity_before`, `quantity_moved`, `quantity_after`, `reference_type`, `reference_id`, `note`, `movement_date`) VALUES
(30, 7, 6, 7, 10, 'ENTREE', 0, 10, 10, 'APPROVISIONNEMENT', 46, 'Bon d’approvisionnement 097', '2026-09-30 11:34:21'),
(31, 7, 6, 7, 10, 'SORTIE', 10, 5, 5, 'VENTE', 8, 'Vente FAC-20260930-F98Q', '2026-09-30 11:36:35'),
(32, 7, 6, 8, 10, 'ENTREE', 0, 100, 100, 'APPROVISIONNEMENT', 48, 'Bon d’approvisionnement 1213', '2026-09-30 12:06:03'),
(33, 7, 6, 8, 10, 'SORTIE', 100, 1, 99, 'VENTE', 9, 'Vente FAC-20260930-LGMV', '2026-09-30 12:27:48'),
(34, 7, 6, 9, 10, 'ENTREE', 0, 100, 100, 'APPROVISIONNEMENT', 49, 'Bon d’approvisionnement Aq', '2026-09-30 13:34:29'),
(35, 7, 6, 9, 10, 'SORTIE', 100, 1, 99, 'VENTE', 10, 'Vente FAC-20260930-1LAN', '2026-09-30 13:35:35'),
(36, 7, 6, 7, 10, 'SORTIE', 5, 1, 4, 'VENTE', 10, 'Vente FAC-20260930-1LAN', '2026-09-30 13:35:35'),
(37, 7, 6, 9, 10, 'SORTIE', 99, 1, 98, 'VENTE', 11, 'Vente FAC-20260930-J2QY', '2026-09-30 18:51:33'),
(38, 7, 6, 9, 10, 'SORTIE', 99, 2, 97, 'VENTE', 11, 'Vente FAC-20260930-J2QY', '2026-09-30 18:51:33'),
(39, 7, 6, 8, 10, 'SORTIE', 99, 3, 96, 'VENTE', 11, 'Vente FAC-20260930-J2QY', '2026-09-30 18:51:33'),
(40, 7, 6, 7, 10, 'SORTIE', 4, 1, 3, 'VENTE', 12, 'Vente FAC-20261001-77ZF', '2026-10-01 19:50:11'),
(41, 7, 6, 7, 10, 'ENTREE', 3, 10, 13, 'APPROVISIONNEMENT', 50, 'Approvisionnement validé #50', '2026-10-01 19:55:31'),
(42, 7, 6, 9, 10, 'SORTIE', 96, 1, 95, 'VENTE', 13, 'Vente FAC-20261003-BZW5', '2026-10-03 16:22:48'),
(43, 7, 6, 9, 10, 'SORTIE', 95, 1, 94, 'VENTE', 14, 'Vente FAC-20261003-YI1O', '2026-10-03 17:18:44'),
(44, 7, 6, 9, 10, 'SORTIE', 94, 1, 93, 'VENTE', 15, 'Vente FAC-20261005-CXXA', '2026-10-05 14:13:15'),
(45, 7, 6, 10, 10, 'ENTREE', 0, 50, 50, 'APPROVISIONNEMENT', 51, 'Approvisionnement validé #51', '2026-10-06 10:58:15'),
(46, 7, 6, 10, 10, 'SORTIE', 50, 12, 38, 'VENTE', 16, 'Vente FAC-20261006-JWTA', '2026-10-06 11:07:09'),
(47, 7, 6, 7, 10, 'SORTIE', 13, 2, 11, 'VENTE', 16, 'Vente FAC-20261006-JWTA', '2026-10-06 11:07:09'),
(48, 7, 6, 11, 10, 'ENTREE', 0, 60, 60, 'APPROVISIONNEMENT', 52, 'Bon d’approvisionnement Fugp', '2026-10-08 11:46:02'),
(49, 7, 6, 11, 10, 'SORTIE', 60, 20, 40, 'VENTE', 17, 'Vente FAC-20261008-XMCJ', '2026-10-08 12:04:04'),
(50, 7, 6, 10, 10, 'SORTIE', 38, 2, 36, 'VENTE', 17, 'Vente FAC-20261008-XMCJ', '2026-10-08 12:04:04'),
(51, 9, 8, 13, 13, 'ENTREE', 0, 20, 20, 'APPROVISIONNEMENT', 53, 'Bon d’approvisionnement Zadd', '2026-10-09 16:57:59'),
(52, 9, 8, 12, 13, 'ENTREE', 0, 50, 50, 'APPROVISIONNEMENT', 54, 'Bon d’approvisionnement R5g', '2026-10-09 17:02:36'),
(53, 9, 8, 13, 13, 'SORTIE', 20, 5, 15, 'SORTIE_STOCK', 55, 'Expiration', '2026-10-09 17:08:35'),
(54, 9, 8, 13, 13, 'SORTIE', 15, 3, 12, 'VENTE', 18, 'Vente FAC-20261009-MH0F', '2026-10-09 17:18:51'),
(55, 9, 8, 12, 13, 'SORTIE', 50, 20, 30, 'VENTE', 18, 'Vente FAC-20261009-MH0F', '2026-10-09 17:18:51'),
(56, 7, 6, 14, 10, 'ENTREE', 0, 1000, 1000, 'APPROVISIONNEMENT', 56, 'Bon d’approvisionnement Re', '2026-10-10 15:53:23'),
(57, 7, 6, 14, 10, 'SORTIE', 1000, 1, 999, 'VENTE', 19, 'Vente FAC-20261010-YB7D', '2026-10-10 15:54:36'),
(58, 7, 6, 9, 10, 'SORTIE', 93, 1, 92, 'VENTE', 19, 'Vente FAC-20261010-YB7D', '2026-10-10 15:54:36'),
(59, 7, 6, 9, 10, 'SORTIE', 92, 1, 91, 'VENTE', 20, 'Vente FAC-20261010-P6IG', '2026-10-10 17:26:10'),
(60, 7, 6, 14, 10, 'SORTIE', 999, 1, 998, 'VENTE', 20, 'Vente FAC-20261010-P6IG', '2026-10-10 17:26:10'),
(61, 7, 6, 9, 10, 'SORTIE', 91, 1, 90, 'VENTE', 21, 'Vente FAC-20261010-XWWI', '2026-10-10 18:03:10'),
(62, 7, 6, 14, 10, 'SORTIE', 998, 1, 997, 'VENTE', 21, 'Vente FAC-20261010-XWWI', '2026-10-10 18:03:11'),
(63, 8, 7, 15, 12, 'ENTREE', 0, 50, 50, 'APPROVISIONNEMENT', 57, 'Bon d’approvisionnement 1d5g', '2026-10-11 10:47:53'),
(64, 8, 7, 15, 12, 'ENTREE', 50, 20, 70, 'APPROVISIONNEMENT', 58, 'Approvisionnement validé #58', '2026-10-11 10:49:31'),
(65, 8, 7, 15, 12, 'SORTIE', 70, 17, 53, 'VENTE', 22, 'Vente FAC-20261011-Q349', '2026-10-11 10:53:30'),
(66, 7, 6, 10, 10, 'SORTIE', 36, 3, 33, 'SORTIE_STOCK', 59, 'Sortie en stock', '2026-10-11 13:22:16'),
(67, 7, 6, 10, 10, 'SORTIE', 33, 10, 23, 'SORTIE_STOCK', 60, 'EXXX', '2026-10-11 13:24:07');

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

--
-- Déchargement des données de la table `paiements_fournisseurs`
--

INSERT INTO `paiements_fournisseurs` (`paiement_id`, `entreprise_id`, `achat_id`, `mode_paiement_id`, `banque_id`, `caisse_id`, `user_id`, `amount`, `reference`, `payment_date`) VALUES
(6, 7, 46, 1, NULL, 7, 10, 1000.00, '', '2026-09-30 13:46:34');

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
(6, 7, 10, 1, NULL, 7, 10, 1500.00, 1500.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-09-30 13:24:43'),
(7, 7, 10, 1, NULL, 8, 10, 12500.00, 12500.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-09-30 13:26:45'),
(8, 7, 8, 1, NULL, 7, 10, 745.00, 745.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-09-30 13:31:09'),
(9, 7, 9, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-09-30 13:31:15'),
(10, 7, 11, 3, 2, 9, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, 'HHHH', 'PAYMENT', '2026-09-30 16:54:36'),
(11, 7, 11, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-09-30 16:55:10'),
(12, 7, 11, 2, NULL, 10, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, 'HHHH', 'PAYMENT', '2026-09-30 16:56:28'),
(13, 7, 11, 1, NULL, 8, 10, 37500.00, 37500.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-09-30 16:56:39'),
(14, 7, 12, 1, NULL, 7, 10, 120.00, 120.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-01 17:51:01'),
(15, 7, 15, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-05 12:13:56'),
(16, 7, 17, 1, NULL, 7, 10, 200.00, 200.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-08 10:06:56'),
(17, 9, 18, 1, NULL, 11, 13, 50000.00, 50000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-09 15:29:37'),
(18, 9, 18, 1, NULL, 11, 13, 10000.00, 10000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-09 15:30:58'),
(19, 9, 18, 1, NULL, 11, 13, 8000.00, 8000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-09 15:31:58'),
(20, 7, 19, 1, NULL, 7, 10, 10.00, 23000.00, 'USD', 'CDF', 2300.0000000000, '', 'PAYMENT', '2026-10-10 15:10:58'),
(21, 7, 19, 1, NULL, 8, 10, 7000.00, 7000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-10 15:12:34'),
(22, 7, 19, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-10 15:59:27'),
(23, 7, 20, 1, NULL, 7, 10, 10.00, 23000.00, 'USD', 'CDF', 2300.0000000000, '', 'PAYMENT', '2026-10-10 15:59:53'),
(24, 7, 20, 1, NULL, 8, 10, 27000.00, 27000.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-10 16:00:03'),
(25, 7, 20, 1, NULL, 8, 10, 11500.00, 5.00, 'CDF', 'USD', 0.0004347826, '', 'PAYMENT', '2026-10-10 16:04:42'),
(26, 7, 21, 1, NULL, 7, 10, 2.17, 4991.00, 'USD', 'CDF', 2300.0000000000, '', 'PAYMENT', '2026-10-10 16:05:17'),
(27, 7, 13, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-10 23:24:29'),
(28, 7, 14, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-10 23:24:34'),
(29, 7, 16, 1, NULL, 7, 10, 580.00, 580.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-10 23:24:37'),
(30, 7, 21, 1, NULL, 8, 10, 9.00, 9.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-10 23:25:13'),
(31, 7, 21, 1, NULL, 7, 10, 5.00, 5.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-10 23:25:18'),
(32, 7, 17, 1, NULL, 7, 10, 80.00, 80.00, 'USD', 'USD', 1.0000000000, '', 'PAYMENT', '2026-10-10 23:25:45');

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

CREATE TABLE `produits` (
  `produit_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `fournisseur_id` int(11) DEFAULT NULL,
  `sku` varchar(50) NOT NULL COMMENT 'Code barre unique',
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `unit_price` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Prix de vente',
  `cost_price` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Prix d achat',
  `monais` varchar(10) NOT NULL,
  `unite_de_mesure` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `est_perisable` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`produit_id`, `entreprise_id`, `category_id`, `fournisseur_id`, `sku`, `name`, `description`, `unit_price`, `cost_price`, `monais`, `unite_de_mesure`, `is_active`, `created_at`, `est_perisable`) VALUES
(7, 7, 6, NULL, '121', 'Ordinateur ', '', 0.00, 0.00, 'USD', 11, 1, '2026-09-30 09:31:01', 0),
(8, 7, NULL, NULL, 'S', 'Service ', '', 0.00, 0.00, 'USD', 13, 1, '2026-09-30 09:31:55', 0),
(9, 7, 7, NULL, 'Inst', 'Installation de la machine', '', 5.00, 0.00, 'USD', 13, 1, '2026-09-30 11:33:59', 0),
(10, 7, 6, NULL, '1231', 'Gel', '', 0.00, 0.00, 'USD', 14, 1, '2026-10-06 08:45:50', 1),
(11, 7, 8, NULL, '1211', 'Paracetamol', '', 0.00, 0.00, 'USD', 11, 1, '2026-10-08 09:40:04', 1),
(12, 9, 10, NULL, 'Riz oni', 'Riz', '', 0.00, 0.00, 'CDF', 16, 1, '2026-10-09 14:49:46', 0),
(13, 9, 10, NULL, 'Sar', 'Sardine', '', 0.00, 0.00, 'CDF', 17, 1, '2026-10-09 14:51:38', 1),
(14, 7, NULL, NULL, '1', 'Installation réseau ', '', 0.00, 0.00, 'CDF', 13, 1, '2026-10-10 13:52:22', 0),
(15, 8, 12, NULL, 'Ae', 'Désinfectant ', '', 0.00, 0.00, 'USD', 18, 1, '2026-10-11 08:44:20', 1),
(16, 8, 11, NULL, 'A', 'Sardine', '', 0.00, 0.00, 'CDF', 19, 1, '2026-10-11 08:45:06', 1);

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
(11, 7, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(12, 7, 'Comptabilité', '[\"comptabilite\",\"voir_comptabilite\",\"creer_comptabilite\",\"modifier_comptabilite\"]', ''),
(13, 8, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(14, 8, 'Vente', '[\"vente\",\"voir_ventes\",\"creer_ventes\",\"modifier_ventes\",\"approvisionnement\",\"voir_stock\",\"voir_succursales\",\"voir_fournisseurs\",\"creer_fournisseurs\",\"voir_approvisionnements\",\"creer_approvisionnements\"]', ''),
(15, 9, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(16, 9, 'Vendeur', '[\"vente\",\"voir_ventes\",\"creer_ventes\",\"modifier_ventes\",\"stock\",\"voir_stock\",\"modifier_stock\",\"creer_produit\",\"modifier_produit\",\"supprimer_produit\",\"voir_succursales\",\"voir_fournisseurs\",\"creer_fournisseurs\",\"modifier_fournisseurs\",\"supprimer_fournisseurs\",\"voir_approvisionnements\",\"creer_approvisionnements\",\"approvisionnement\"]', '');

-- --------------------------------------------------------

--
-- Structure de la table `stocks`
--

CREATE TABLE `stocks` (
  `stock_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `succursale_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `min_stock_level` int(11) NOT NULL DEFAULT 5 COMMENT 'Alerte si stock < a ce niveau',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `stocks`
--

INSERT INTO `stocks` (`stock_id`, `entreprise_id`, `succursale_id`, `produit_id`, `quantity`, `min_stock_level`, `updated_at`) VALUES
(23, 7, 6, 7, 11, 10, '2026-10-06 09:07:09'),
(24, 7, 6, 8, 96, 5, '2026-09-30 16:51:33'),
(27, 7, 6, 9, 90, 5, '2026-10-10 16:03:10'),
(30, 7, 6, 10, 23, 5, '2026-10-11 11:24:07'),
(33, 7, 6, 11, 40, 50, '2026-10-08 10:04:04'),
(37, 9, 8, 12, 30, 10, '2026-10-09 15:18:51'),
(38, 9, 8, 13, 12, 5, '2026-10-09 15:18:51'),
(42, 7, 6, 14, 997, 5, '2026-10-10 16:03:11'),
(44, 8, 7, 15, 53, 10, '2026-10-11 08:53:30'),
(45, 8, 7, 16, 0, 5, '2026-10-11 08:45:06');

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
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `succursales`
--

INSERT INTO `succursales` (`succursale_id`, `entreprise_id`, `name`, `code`, `est_sucursal_mere`, `address`, `phone`) VALUES
(6, 7, 'ALBERT TECHNOLOGIE', 'MERE', 1, 'Province Du Nord Kivu/République Démocratique du Congo', '0981326086'),
(7, 8, 'Bcz', 'MERE', 1, 'Musien Hopital', '0967289836'),
(8, 9, 'ALIMENTATION SALAMA', 'MERE', 1, 'Oïcha Moba', '0967289836');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `super_admins`
--

INSERT INTO `super_admins` (`super_admin_id`, `email`, `password_hash`, `full_name`, `is_active`, `created_at`) VALUES
(1, 'admin@gmail.com', '$2y$10$0HOmG7bF5gbXQqmXRDGa7ONEA6QtgJtEktt4qgJ4maGwrJLzU4ni2', 'superAlbert', 1, '2026-09-23 19:58:15');

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
(7, 7, 'USD', 2300.0000000000, 10, '2026-10-10 15:42:30', '2026-10-10 15:42:30');

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
  `quantity` int(11) NOT NULL,
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
(10, 7, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-09-30 09:38:04'),
(11, 7, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-09-30 13:25:55'),
(14, 9, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-10-09 15:23:22'),
(15, 8, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-10-11 08:54:53'),
(16, 8, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-10-11 08:55:04');

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
(11, 7, 'Pièces', '', '2026-09-30 09:28:45', 'Pcs'),
(12, 7, 'Kilogramme', '', '2026-09-30 09:29:04', 'Kg'),
(13, 7, 'service', '', '2026-09-30 09:29:42', 'service'),
(14, 7, 'Litres', '', '2026-10-06 08:42:43', 'L'),
(16, 9, 'Kilogramme', '', '2026-10-09 14:43:01', 'Kg'),
(17, 9, 'Pièces', '', '2026-10-09 14:50:32', 'Pcs'),
(18, 8, 'Litres', '', '2026-10-11 08:40:03', 'L'),
(19, 8, 'Kilogramme', '', '2026-10-11 08:40:18', 'Kg');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`user_id`, `entreprise_id`, `succursale_id`, `role_id`, `username`, `email`, `password_hash`, `full_name`, `is_active`, `created_at`) VALUES
(10, 7, 6, 11, 'Alberto', 'alberttech@gmail.com', '$2y$10$knMcXzlnuuO8KW.OGg7S2.tXFlcP6Mk2PXxRFBjtrT0Bxnmn63Edm', 'Alberson NDALIKO', 1, '2026-09-30 09:26:41'),
(11, 7, 6, 12, 'Compte', 'compte@gmail.com', '$2y$10$RrBW2E4UKhjREfKpH4OenO53VcLl8fG48FQie1LOua10WVThSR9YW', 'Compte', 1, '2026-10-05 11:35:56'),
(12, 8, 7, 13, 'Abiba', 'abiba@gmail.com', '$2y$10$UgSwBBcjkNvhcng3ilHtg.Iezv1yh179aaoIEXIiO96SS7FbNYEKK', 'Musien Hopital', 1, '2026-10-08 14:56:24'),
(13, 9, 8, 15, 'Ojcd', 'ojcd@gmail.com', '$2y$10$8qAErnqdb1vNzpyOXG/COOUZBqT1F/BnLFy0s6tsRiuEU0mrH5uhG', 'Musien Hopital', 1, '2026-10-09 14:28:41'),
(14, 9, NULL, 16, 'Zadock', 'zadock@gmail.com', '$2y$10$7XMDlX1W9hNnZYM1uP6kvuX7ImCI5jW.fGr0qw0a0eUWd5uZbRZwS', 'Zadock', 1, '2026-10-09 14:38:44');

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
(8, 7, 6, NULL, 10, NULL, NULL, 'FAC-20260930-F98Q', '2026-09-30 11:36:33', 745.00, 'USD', 745.00, 'PAID', NULL, '2026-09-30 09:36:33'),
(9, 7, 6, NULL, 10, 3, NULL, 'FAC-20260930-LGMV', '2026-09-30 12:27:48', 5.00, 'USD', 5.00, 'PAID', NULL, '2026-09-30 10:27:48'),
(10, 7, 6, NULL, 10, 3, NULL, 'FAC-20260930-1LAN', '2026-09-30 13:35:35', 0.00, NULL, 0.00, 'PAID', NULL, '2026-09-30 11:35:35'),
(11, 7, 6, NULL, 10, NULL, NULL, 'FAC-20260930-J2QY', '2026-09-30 18:51:32', 0.00, NULL, 0.00, 'PAID', NULL, '2026-09-30 16:51:32'),
(12, 7, 6, NULL, 10, 4, NULL, 'FAC-20261001-77ZF', '2026-10-01 19:50:11', 120.00, 'USD', 120.00, 'PAID', NULL, '2026-10-01 17:50:11'),
(13, 7, 6, NULL, 10, 5, NULL, 'FAC-20261003-BZW5', '2026-10-03 16:22:48', 5.00, 'USD', 5.00, 'PAID', NULL, '2026-10-03 14:22:48'),
(14, 7, 6, NULL, 10, NULL, 'NAOMIE KETSIA', 'FAC-20261003-YI1O', '2026-10-03 17:18:44', 5.00, 'USD', 5.00, 'PAID', NULL, '2026-10-03 15:18:44'),
(15, 7, 6, NULL, 10, NULL, 'Abiba', 'FAC-20261005-CXXA', '2026-10-05 14:13:15', 5.00, 'USD', 5.00, 'PAID', NULL, '2026-10-05 12:13:15'),
(16, 7, 6, NULL, 10, 7, NULL, 'FAC-20261006-JWTA', '2026-10-06 11:07:08', 580.00, 'USD', 580.00, 'PAID', NULL, '2026-10-06 09:07:08'),
(17, 7, 6, NULL, 10, 7, NULL, 'FAC-20261008-XMCJ', '2026-10-08 12:04:04', 280.00, 'USD', 280.00, 'PAID', NULL, '2026-10-08 10:04:04'),
(18, 9, 8, NULL, 13, NULL, 'Isaac', 'FAC-20261009-MH0F', '2026-10-09 17:18:51', 68000.00, 'CDF', 68000.00, 'PAID', NULL, '2026-10-09 15:18:51'),
(19, 7, 6, NULL, 10, NULL, 'Ndaliko', 'FAC-20261010-YB7D', '2026-10-10 15:54:36', 0.00, NULL, 0.00, 'PAID', NULL, '2026-10-10 13:54:36'),
(20, 7, 6, NULL, 10, NULL, 'Obadi', 'FAC-20261010-P6IG', '2026-10-10 17:26:10', 0.00, NULL, 0.00, 'PAID', NULL, '2026-10-10 15:26:10'),
(21, 7, 6, NULL, 10, NULL, 'Ong', 'FAC-20261010-XWWI', '2026-10-10 18:03:10', 0.00, NULL, 0.00, 'PAID', NULL, '2026-10-10 16:03:10'),
(22, 8, 7, NULL, 12, NULL, 'Abaiba', 'FAC-20261011-Q349', '2026-10-11 10:53:30', 102.00, 'USD', 0.00, 'PENDING', NULL, '2026-10-11 08:53:30');

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
  `quantity` int(11) NOT NULL,
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
(10, 7, 8, 7, 'USD', 5, 150.00, 0.67, 745.00, 5.00, '2026-09-30 09:36:34'),
(11, 7, 9, 8, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-09-30 10:27:48'),
(12, 7, 10, 9, 'CDF', 1, 12500.00, 0.00, 12500.00, 0.00, '2026-09-30 11:35:35'),
(13, 7, 10, 7, 'USD', 1, 1500.00, 0.00, 1500.00, 0.00, '2026-09-30 11:35:35'),
(14, 7, 11, 9, 'CDF', 1, 12500.00, 0.00, 12500.00, 0.00, '2026-09-30 16:51:32'),
(15, 7, 11, 9, 'CDF', 2, 12500.00, 0.00, 25000.00, 0.00, '2026-09-30 16:51:33'),
(16, 7, 11, 8, 'USD', 3, 5.00, 0.00, 15.00, 0.00, '2026-09-30 16:51:33'),
(17, 7, 12, 7, 'USD', 1, 120.00, 0.00, 120.00, 0.00, '2026-10-01 17:50:11'),
(18, 7, 13, 9, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-10-03 14:22:48'),
(19, 7, 14, 9, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-10-03 15:18:44'),
(20, 7, 15, 9, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-10-05 12:13:15'),
(21, 7, 16, 10, 'USD', 12, 15.00, 0.00, 180.00, 0.00, '2026-10-06 09:07:08'),
(22, 7, 16, 7, 'USD', 2, 200.00, 0.00, 400.00, 0.00, '2026-10-06 09:07:09'),
(23, 7, 17, 11, 'USD', 20, 12.00, 0.00, 240.00, 0.00, '2026-10-08 10:04:04'),
(24, 7, 17, 10, 'USD', 2, 20.00, 0.00, 40.00, 0.00, '2026-10-08 10:04:04'),
(25, 9, 18, 13, 'CDF', 3, 1500.00, 4.44, 4300.00, 200.00, '2026-10-09 15:18:51'),
(26, 9, 18, 12, 'CDF', 20, 3200.00, 0.47, 63700.00, 300.00, '2026-10-09 15:18:51'),
(27, 7, 19, 14, 'CDF', 1, 30000.00, 0.00, 30000.00, 0.00, '2026-10-10 13:54:36'),
(28, 7, 19, 9, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-10-10 13:54:36'),
(29, 7, 20, 9, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-10-10 15:26:10'),
(30, 7, 20, 14, 'CDF', 1, 50000.00, 0.00, 50000.00, 0.00, '2026-10-10 15:26:10'),
(31, 7, 21, 9, 'USD', 1, 5.00, 0.00, 5.00, 0.00, '2026-10-10 16:03:10'),
(32, 7, 21, 14, 'CDF', 1, 5000.00, 0.00, 5000.00, 0.00, '2026-10-10 16:03:11'),
(33, 8, 22, 15, 'USD', 17, 6.00, 0.00, 102.00, 0.00, '2026-10-11 08:53:30');

-- --------------------------------------------------------

--
-- Structure de la table `vente_detail_lots`
--

CREATE TABLE `vente_detail_lots` (
  `vente_detail_lot_id` int(11) NOT NULL,
  `entreprise_id` int(11) NOT NULL,
  `vente_detail_id` int(11) NOT NULL,
  `achat_detail_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vente_detail_lots`
--

INSERT INTO `vente_detail_lots` (`vente_detail_lot_id`, `entreprise_id`, `vente_detail_id`, `achat_detail_id`, `quantity`, `created_at`) VALUES
(3, 7, 21, 30, 12, '2026-10-06 09:07:09'),
(4, 7, 23, 31, 20, '2026-10-08 10:04:04'),
(5, 7, 24, 30, 2, '2026-10-08 10:04:04'),
(6, 9, 25, 32, 3, '2026-10-09 15:18:51'),
(7, 8, 33, 36, 17, '2026-10-11 08:53:30');

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
(7, 8, 'USD', 745.00, 745.00),
(7, 9, 'USD', 5.00, 5.00),
(7, 10, 'CDF', 12500.00, 12500.00),
(7, 10, 'USD', 1500.00, 1500.00),
(7, 11, 'CDF', 37500.00, 37500.00),
(7, 11, 'USD', 15.00, 15.00),
(7, 12, 'USD', 120.00, 120.00),
(7, 13, 'USD', 5.00, 5.00),
(7, 14, 'USD', 5.00, 5.00),
(7, 15, 'USD', 5.00, 5.00),
(7, 16, 'USD', 580.00, 580.00),
(7, 17, 'USD', 280.00, 280.00),
(7, 19, 'CDF', 30000.00, 30000.00),
(7, 19, 'USD', 5.00, 5.00),
(7, 20, 'CDF', 50000.00, 50000.00),
(7, 20, 'USD', 5.00, 5.00),
(7, 21, 'CDF', 5000.00, 5000.00),
(7, 21, 'USD', 5.00, 5.00),
(8, 22, 'USD', 102.00, 0.00),
(9, 18, 'CDF', 68000.00, 68000.00);

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
  ADD KEY `fk_mouvement_entreprise` (`entreprise_id`),
  ADD KEY `fk_mouvement_caisse` (`caisse_id`),
  ADD KEY `fk_mouvement_user` (`user_id`),
  ADD KEY `fk_mouvement_caisse_mode` (`mode_paiement_id`),
  ADD KEY `idx_mouvement_caisse_banque` (`banque_id`,`movement_date`);

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
  ADD KEY `fk_produit_category` (`category_id`),
  ADD KEY `fk_produit_fournisseur` (`fournisseur_id`);

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
  MODIFY `achat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT pour la table `achat_details`
--
ALTER TABLE `achat_details`
  MODIFY `achat_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT pour la table `achat_detail_sorties`
--
ALTER TABLE `achat_detail_sorties`
  MODIFY `sortie_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `banques`
--
ALTER TABLE `banques`
  MODIFY `banque_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `caisse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `clients`
--
ALTER TABLE `clients`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
  MODIFY `demande_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `ecritures_comptables`
--
ALTER TABLE `ecritures_comptables`
  MODIFY `ecriture_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `entreprises`
--
ALTER TABLE `entreprises`
  MODIFY `entreprise_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `fournisseurs`
--
ALTER TABLE `fournisseurs`
  MODIFY `fournisseur_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
  MODIFY `mouvement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `mouvements_stock`
--
ALTER TABLE `mouvements_stock`
  MODIFY `mouvement_stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT pour la table `paiements_fournisseurs`
--
ALTER TABLE `paiements_fournisseurs`
  MODIFY `paiement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `paiements_ventes`
--
ALTER TABLE `paiements_ventes`
  MODIFY `paiement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `produit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT pour la table `succursales`
--
ALTER TABLE `succursales`
  MODIFY `succursale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `super_admins`
--
ALTER TABLE `super_admins`
  MODIFY `super_admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `type_caisse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `unites_mesure`
--
ALTER TABLE `unites_mesure`
  MODIFY `unite_mesure_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `ventes`
--
ALTER TABLE `ventes`
  MODIFY `vente_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `vente_details`
--
ALTER TABLE `vente_details`
  MODIFY `vente_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT pour la table `vente_detail_lots`
--
ALTER TABLE `vente_detail_lots`
  MODIFY `vente_detail_lot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
-- Contraintes pour la table `vente_totaux_monnaies`
--
ALTER TABLE `vente_totaux_monnaies`
  ADD CONSTRAINT `fk_vente_totaux_entreprise` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`entreprise_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_vente_totaux_vente` FOREIGN KEY (`vente_id`) REFERENCES `ventes` (`vente_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
