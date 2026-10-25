-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 25 oct. 2026 à 16:47
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
(66, 13, 13, NULL, 20, '109J', '2026-10-24 20:32:08', '2026-10-24 20:32:08', 90.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-24 18:32:08'),
(67, 13, 14, NULL, 22, 'jj', '2026-10-24 20:34:25', '2026-10-24 20:34:25', 48.00, 0.00, 'USD', 'IN', '', 'CANCELLED', '2026-10-24 18:34:25'),
(68, 13, 13, NULL, 20, 'é\"fr', '2026-10-25 10:23:53', '2026-10-25 10:23:53', 120.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-25 09:23:53'),
(69, 13, 13, 11, 20, '1k', '2026-10-25 15:16:49', '2026-10-25 15:16:49', 2000.00, 0.00, 'USD', 'IN', '', 'RECEIVED', '2026-10-25 14:16:49');

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
(32, 9, 53, 13, 20, '2026-10-12', 8, 1000.00, 20000.00, '2026-10-09 14:57:59'),
(33, 9, 54, 12, 50, NULL, 0, 3000.00, 150000.00, '2026-10-09 15:02:36'),
(34, 9, 55, 13, 5, NULL, 0, 0.00, 0.00, '2026-10-09 15:08:35'),
(43, 12, 64, 19, 10, '2026-10-15', 5, 10.00, 100.00, '2026-10-12 15:38:05'),
(45, 13, 66, 21, 10, '2026-11-08', 0, 9.00, 90.00, '2026-10-24 18:32:08'),
(46, 13, 67, 21, 12, '2026-10-31', 0, 4.00, 48.00, '2026-10-24 18:34:25'),
(47, 13, 68, 21, 12, '2026-10-26', 0, 10.00, 120.00, '2026-10-25 09:23:53'),
(48, 13, 69, 24, 20, NULL, 0, 100.00, 2000.00, '2026-10-25 14:16:49');

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
(6, 9, 34, 32, 5, '2026-10-09 15:08:35');

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
(19, 13, 13, 22, 1, NULL, 20, 'caisse $', '2026-10-20 16:09:39', NULL, 0.00, 25.00, 0.00, 'OUVERTE', '2026-10-20 14:09:39'),
(20, 13, 14, 22, 1, NULL, 22, 'Caisse $', '2026-10-22 20:29:45', NULL, 0.00, 0.00, 0.00, 'OUVERTE', '2026-10-22 18:29:45'),
(21, 13, 14, 21, 1, NULL, 22, 'Caisse fc', '2026-10-22 20:30:01', NULL, 0.00, 0.00, 0.00, 'OUVERTE', '2026-10-22 18:30:01'),
(22, 13, 14, 22, 3, 3, 23, 'BANQUE COOPEC', '2026-10-23 22:32:37', NULL, 0.00, 900.00, 0.00, 'OUVERTE', '2026-10-23 20:32:37');

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
(15, 13, 'Installation ', '');

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

--
-- Déchargement des données de la table `demandes_annulation_mouvements_caisse`
--

INSERT INTO `demandes_annulation_mouvements_caisse` (`demande_id`, `entreprise_id`, `mouvement_id`, `demandeur_id`, `motif`, `statut`, `decision_par`, `motif_decision`, `mouvement_compensation_id`, `created_at`, `decision_at`) VALUES
(2, 13, 74, 23, 'DKDK', 'REFUSEE', 20, '', NULL, '2026-10-23 20:27:14', '2026-10-23 22:29:58'),
(3, 13, 75, 23, 'EKE', 'EN_ATTENTE', NULL, NULL, NULL, '2026-10-23 20:34:22', NULL),
(4, 13, 77, 23, 'JJ', 'EN_ATTENTE', NULL, NULL, NULL, '2026-10-23 20:38:26', NULL);

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
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(23) DEFAULT NULL,
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
(9, 'ALIMENTATION SALAMA', 'ojcd@gmail.com', '0967289836', 'Oïcha Moba', NULL, NULL, NULL, NULL, 2, 1, '2026-10-09 14:28:41'),
(12, 'bcz musienene', 'bibihenriet@gmail.com', '0998967065', 'ZS MUSIENENE', NULL, NULL, NULL, NULL, 2, 1, '2026-10-12 15:20:16'),
(13, 'ALBERT WORK TECHNOLOGIE', 'albertwork40@gmail.com', '+243981326086', 'République démocratique du Congo / Nord-kivu /ville de Beni', '', '', 'backend/uploads/companies/13/logo-0b2f3b8dad6d519220700186ccb18bb2.png', 'backend/uploads/companies/13/stamp-f013be8fb0b89b24905da15fdb168155.png', 2, 1, '2026-10-20 10:29:01'),
(15, 'NDALIPHAR', 'albertworkgit@gmail.com', '+243827738', 'BENI', NULL, NULL, NULL, NULL, 2, 0, '2026-10-24 16:58:54');

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
(9, '[\"stock\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-10-09 14:30:37'),
(12, '[\"stock\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-10-12 15:21:30'),
(13, '[\"stock\",\"approvisionnements\",\"ventes\",\"caisse\",\"comptabilite\",\"utilisateurs\",\"rapports\",\"administration\"]', '2026-10-20 10:29:25'),
(15, '[]', '2026-10-24 16:58:54');

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
(11, 13, NULL, 'ndaliko', '', '', '', '');

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
(71, 13, 19, 20, 1, NULL, '', 'SORTIE', 5.00, 'Remboursement vente FAC-20261020-SFH5', 29, NULL, NULL, '2026-10-20 21:35:01'),
(72, 13, 19, 20, 1, NULL, '', 'SORTIE', 5.00, 'Remboursement vente FAC-20261020-S4LM', 30, NULL, NULL, '2026-10-20 21:37:23'),
(73, 13, 21, 22, 1, NULL, '', 'ENTREE', 10.00, 'Paiement vente FAC-20261022-SS7E', 31, NULL, NULL, '2026-10-22 20:32:17'),
(74, 13, 21, 22, 1, NULL, NULL, 'SORTIE', 10.00, 'Sortie', NULL, NULL, NULL, '2026-10-22 20:35:17'),
(75, 13, 22, 23, 3, 3, '0029', 'ENTREE', 1000.00, 'DEPOS', NULL, NULL, NULL, '2026-10-23 22:33:25'),
(76, 13, 22, 23, 3, 3, 'ZEJ2', 'ENTREE', 100.00, 'DEPOS', NULL, NULL, NULL, '2026-10-23 22:33:56'),
(77, 13, 22, 23, 3, 3, 'DD', 'SORTIE', 100.00, 'RETRAIT', NULL, NULL, NULL, '2026-10-23 22:35:23'),
(78, 13, 22, 23, 3, 3, 'D', 'SORTIE', 100.00, 'ZJ', NULL, NULL, NULL, '2026-10-23 22:36:18'),
(79, 13, 19, 20, 1, NULL, NULL, 'ENTREE', 10.00, 's', NULL, NULL, NULL, '2026-10-24 13:01:24'),
(80, 13, 19, 20, 1, NULL, NULL, 'ENTREE', 10.00, 'Entre', NULL, NULL, NULL, '2026-10-25 16:28:29'),
(81, 13, 19, 20, 1, NULL, NULL, 'ENTREE', 5.00, 'Enter', NULL, NULL, NULL, '2026-10-25 16:29:31');

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
(51, 9, 8, 13, 13, 'ENTREE', 0, 20, 20, 'APPROVISIONNEMENT', 53, 'Bon d’approvisionnement Zadd', '2026-10-09 16:57:59'),
(52, 9, 8, 12, 13, 'ENTREE', 0, 50, 50, 'APPROVISIONNEMENT', 54, 'Bon d’approvisionnement R5g', '2026-10-09 17:02:36'),
(53, 9, 8, 13, 13, 'SORTIE', 20, 5, 15, 'SORTIE_STOCK', 55, 'Expiration', '2026-10-09 17:08:35'),
(54, 9, 8, 13, 13, 'SORTIE', 15, 3, 12, 'VENTE', 18, 'Vente FAC-20261009-MH0F', '2026-10-09 17:18:51'),
(55, 9, 8, 12, 13, 'SORTIE', 50, 20, 30, 'VENTE', 18, 'Vente FAC-20261009-MH0F', '2026-10-09 17:18:51'),
(76, 12, 12, 19, 19, 'ENTREE', 0, 10, 10, 'APPROVISIONNEMENT', 64, 'Bon d’approvisionnement 1egy', '2026-10-12 17:38:05'),
(77, 12, 12, 19, 19, 'SORTIE', 10, 5, 5, 'VENTE', 26, 'Vente FAC-20261012-VFHL', '2026-10-12 17:40:31'),
(80, 13, 13, 21, 20, 'ENTREE', 0, 10, 10, 'APPROVISIONNEMENT', 66, 'Bon d’approvisionnement 109J', '2026-10-24 20:32:08'),
(81, 13, 14, 21, 22, 'ENTREE', 0, 12, 12, 'APPROVISIONNEMENT', 67, 'Bon d’approvisionnement jj', '2026-10-24 20:34:25'),
(82, 13, 14, 21, 22, 'SORTIE', 12, 12, 0, 'ANNULATION_APPROVISIONNEMENT', 67, 'Annulation dans les 48 h #67', '2026-10-24 20:39:34'),
(83, 13, 13, 21, 20, 'ENTREE', 10, 12, 22, 'APPROVISIONNEMENT', 68, 'Bon d’approvisionnement é\"fr', '2026-10-25 10:23:53'),
(84, 13, 13, 20, 20, 'AJUSTEMENT', 0, 10, 10, 'AJUSTEMENT', NULL, 'Ajustement manuel : set', '2026-10-25 10:40:34'),
(85, 13, 13, 24, 20, 'ENTREE', 0, 20, 20, 'APPROVISIONNEMENT', 69, 'Bon d’approvisionnement 1k', '2026-10-25 15:16:49');

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
(42, 13, 31, 1, NULL, 21, 22, 10.00, 10.00, 'CDF', 'CDF', 1.0000000000, '', 'PAYMENT', '2026-10-22 18:32:17');

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

INSERT INTO `produits` (`produit_id`, `entreprise_id`, `succursale_origine_id`, `category_id`, `fournisseur_id`, `sku`, `name`, `description`, `unit_price`, `cost_price`, `monais`, `unite_de_mesure`, `is_active`, `created_at`, `est_perisable`) VALUES
(12, 9, 8, 10, NULL, 'Riz oni', 'Riz', '', 0.00, 0.00, 'CDF', 16, 1, '2026-10-09 14:49:46', 0),
(13, 9, 8, 10, NULL, 'Sar', 'Sardine', '', 0.00, 0.00, 'CDF', 17, 1, '2026-10-09 14:51:38', 1),
(19, 12, 12, 14, NULL, '1', 'Désinfectant ', '', 0.00, 0.00, 'USD', 20, 1, '2026-10-12 15:35:00', 1),
(20, 13, 13, 15, NULL, 'od', 'odrinateur', '', 0.00, 0.00, 'USD', 22, 1, '2026-10-24 09:13:49', 0),
(21, 13, 13, NULL, NULL, 'jk', 'jus', '', 0.00, 0.00, 'USD', 23, 1, '2026-10-24 18:19:36', 0),
(24, 13, 13, NULL, NULL, 's', 'camera', '', 80.00, 0.00, 'USD', 22, 1, '2026-10-25 10:03:33', 0);

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
(26, 15, 'Administrateur', '[\"*\",\"toutes_succursales\"]', 'Administrateur de l’entreprise'),
(27, 13, 'tous', '[\"vente\",\"voir_ventes\",\"creer_ventes\",\"modifier_ventes\",\"caisse\",\"voir_caisse\",\"creer_caisse\",\"modifier_caisse\",\"supprimer_caisse\",\"stock\",\"voir_stock\",\"modifier_stock\",\"creer_produit\",\"modifier_produit\",\"supprimer_produit\",\"voir_succursales\",\"voir_fournisseurs\",\"creer_fournisseurs\",\"modifier_fournisseurs\",\"supprimer_fournisseurs\",\"voir_approvisionnements\",\"creer_approvisionnements\",\"approvisionnement\",\"comptabilite\",\"voir_comptabilite\",\"creer_comptabilite\",\"modifier_comptabilite\",\"demandes\",\"gerer_demandes\",\"voir_clients\",\"gerer_clients\"]', '');

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
(37, 9, 8, 12, 30, 10, '2026-10-09 15:18:51'),
(38, 9, 8, 13, 12, 5, '2026-10-09 15:18:51'),
(53, 12, 12, 19, 5, 5, '2026-10-12 15:40:31'),
(57, 13, 13, 20, 10, 5, '2026-10-25 09:40:34'),
(58, 13, 13, 21, 22, 5, '2026-10-25 09:23:53'),
(60, 13, 14, 21, 0, 5, '2026-10-24 18:39:34'),
(64, 13, 13, 24, 20, 5, '2026-10-25 14:16:49');

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
  `phone` varchar(23) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `succursales`
--

INSERT INTO `succursales` (`succursale_id`, `entreprise_id`, `name`, `code`, `est_sucursal_mere`, `partager_produits_mere`, `address`, `phone`) VALUES
(8, 9, 'ALIMENTATION SALAMA', 'MERE', 1, 1, 'Oïcha Moba', '0967289836'),
(12, 12, 'bcz musienene', 'MERE', 1, 1, 'ZS MUSIENENE', '0998967065'),
(13, 13, 'ALBERT WORK', 'MERE', 1, 1, 'République démocratique du Congo / Nord-kivu /ville de Beni', '+243981326086'),
(14, 13, 'Matonge', '40', 0, 0, 'Ville de beni quartier matonge', '+243981326086'),
(16, 15, 'NDALIPHAR', 'MERE', 1, 1, 'BENI', '+243827738');

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
(14, 9, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-10-09 15:23:22'),
(19, 12, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-10-12 15:23:31'),
(21, 13, 'CDF', 'Monnaie CDF', 'Fc', 'Caisse en CDF', 1, '2026-10-20 14:09:06'),
(22, 13, 'USD', 'Monnaie USD', '$', 'Caisse en USD', 1, '2026-10-20 14:09:39');

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
(23, 13, 'Un', '', '2026-10-20 10:32:13', '1');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`user_id`, `entreprise_id`, `succursale_id`, `role_id`, `username`, `email`, `password_hash`, `full_name`, `is_active`, `preferred_language`, `created_at`) VALUES
(13, 9, 8, 15, 'Ojcd', 'ojcd@gmail.com', '$2y$10$8qAErnqdb1vNzpyOXG/COOUZBqT1F/BnLFy0s6tsRiuEU0mrH5uhG', 'Musien Hopital', 1, 'fr', '2026-10-09 14:28:41'),
(14, 9, NULL, 16, 'Zadock', 'zadock@gmail.com', '$2y$10$7XMDlX1W9hNnZYM1uP6kvuX7ImCI5jW.fGr0qw0a0eUWd5uZbRZwS', 'Zadock', 1, 'fr', '2026-10-09 14:38:44'),
(19, 12, 12, 21, 'BCZ MUSIENENE', 'bibihenriet@gmail.com', '$2y$10$2j.dUM5ctBVZsAl8MbAGSO1X61/Oqjt3viZTfPhMy8kluVeMda7Em', 'Henriette Bibisombe', 1, 'fr', '2026-10-12 15:20:16'),
(20, 13, 13, 22, 'alberson', 'albertwork40@gmail.com', '$2y$10$Gq8DHxvhu3yVx7yWYCug1exkEfkGlHmrPAHrt34OALatsAlb3axEy', 'Albert', 1, 'fr', '2026-10-20 10:29:02'),
(21, 13, 14, 23, 'Vd', 'vd@gmail.com', '$2y$10$a/lrhmoBX8y6Z07OCTNqk.LabRmQEu8J6tiIrc1DJ5mLZ22GECKPm', 'Vendeur', 1, 'ln', '2026-10-22 18:05:43'),
(22, 13, 14, 27, 'James', 'jm@gmail.com', '$2y$10$xvc0eso8hWsdxaRg7PR4c.cPQLxtCntXApzl03wV2T8LaUj/mCvdG', 'Jm', 1, 'fr', '2026-10-22 18:06:26'),
(23, 13, 13, 23, 'Ad', 'ad@gmail.com', '$2y$10$GpsoOGcFpNnEihL3H1fRJuuf8VAyH9spMj6pWfGCdZ/WDsDeWFthm', 'Ad', 1, 'fr', '2026-10-22 18:39:57'),
(26, 15, 16, 26, 'ALBA', 'albertworkgit@gmail.com', '$2y$10$7jpK4JNjImmPU1VJW0Ofc.h9oLyk4O50qGoVKgGL/u.evgPiVI40i', 'BENI', 0, 'fr', '2026-10-24 16:58:54');

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
(31, 13, 14, NULL, 21, NULL, 'Naomie katsia', 'FAC-20261022-SS7E', '2026-10-22 20:17:32', 10.00, 'CDF', 10.00, 'PAID', NULL, '2026-10-22 18:17:32'),
(32, 13, 13, NULL, 23, NULL, 'Ys', 'FAC-20261024-SOCT', '2026-10-24 19:19:21', 20.00, 'USD', 0.00, 'PENDING', NULL, '2026-10-24 17:19:21');

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
(25, 9, 18, 13, 'CDF', 3, 1500.00, 4.44, 4300.00, 200.00, '2026-10-09 15:18:51'),
(26, 9, 18, 12, 'CDF', 20, 3200.00, 0.47, 63700.00, 300.00, '2026-10-09 15:18:51'),
(39, 12, 26, 19, 'USD', 5, 12.00, 0.00, 60.00, 0.00, '2026-10-12 15:40:31');

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
(6, 9, 25, 32, 3, '2026-10-09 15:18:51'),
(8, 12, 39, 43, 5, '2026-10-12 15:40:31');

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
(3, 13, 31, 'Installation de caméra', 1.000, 10.00, 0.00, 0.00, 'CDF', 10.00, '2026-10-22 18:17:34'),
(4, 13, 32, 'Djdk', 1.000, 20.00, 0.00, 0.00, 'USD', 20.00, '2026-10-24 17:19:21');

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
(13, 31, 'CDF', 10.00, 10.00),
(13, 32, 'USD', 20.00, 0.00);

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
  MODIFY `achat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT pour la table `achat_details`
--
ALTER TABLE `achat_details`
  MODIFY `achat_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

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
-- AUTO_INCREMENT pour la table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `caisse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `clients`
--
ALTER TABLE `clients`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
  MODIFY `entreprise_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `fournisseurs`
--
ALTER TABLE `fournisseurs`
  MODIFY `fournisseur_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
  MODIFY `mouvement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT pour la table `mouvements_stock`
--
ALTER TABLE `mouvements_stock`
  MODIFY `mouvement_stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

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
  MODIFY `paiement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `produit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT pour la table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT pour la table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT pour la table `succursales`
--
ALTER TABLE `succursales`
  MODIFY `succursale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
  MODIFY `type_caisse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `unites_mesure`
--
ALTER TABLE `unites_mesure`
  MODIFY `unite_mesure_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT pour la table `ventes`
--
ALTER TABLE `ventes`
  MODIFY `vente_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT pour la table `vente_details`
--
ALTER TABLE `vente_details`
  MODIFY `vente_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT pour la table `vente_detail_lots`
--
ALTER TABLE `vente_detail_lots`
  MODIFY `vente_detail_lot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `vente_service_details`
--
ALTER TABLE `vente_service_details`
  MODIFY `vente_service_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
