-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:33065
-- Tiempo de generación: 23-05-2025 a las 06:05:03
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `feria`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plantas`
--

CREATE TABLE `plantas` (
  `id_planta` int(11) NOT NULL,
  `nombre_planta` varchar(100) DEFAULT NULL,
  `especie` varchar(100) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `humedad_tierra` varchar(50) NOT NULL,
  `humedad_aire` varchar(50) NOT NULL,
  `temperatura_aire` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `plantas`
--

INSERT INTO `plantas` (`id_planta`, `nombre_planta`, `especie`, `id_usuario`, `humedad_tierra`, `humedad_aire`, `temperatura_aire`) VALUES
(1, 'Pintor', 'Planta de sangre', 1, '25% a 50%', '50% a 70%', '20°C a 30°C'),
(6, 'Giro', 'Girasol', 2, '60% a 80%', '60% a 70%', '20°C a 25°C');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sensores`
--

CREATE TABLE `sensores` (
  `id` int(11) NOT NULL,
  `temperatura` float(5,2) NOT NULL,
  `humedad_tierra` float(5,2) NOT NULL,
  `humedad_aire` float(5,2) NOT NULL,
  `hora_fecha` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `agua` float(5,2) NOT NULL,
  `id_planta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sensores`
--

INSERT INTO `sensores` (`id`, `temperatura`, `humedad_tierra`, `humedad_aire`, `hora_fecha`, `agua`, `id_planta`) VALUES
(1, 24.50, 45.00, 55.00, '2025-05-20 19:33:00', 50.00, 1),
(2, 25.00, 46.00, 54.00, '2025-05-20 19:34:00', 40.00, 1),
(3, 24.80, 44.00, 53.00, '2025-05-20 19:35:08', 35.00, 1),
(4, 25.20, 43.00, 56.00, '2025-05-20 19:36:08', 34.00, 1),
(5, 24.90, 42.00, 55.00, '2025-05-20 19:44:08', 30.80, 1),
(6, 25.10, 41.00, 54.00, '2025-05-20 19:54:08', 25.70, 1),
(7, 24.70, 43.00, 53.00, '2025-05-20 19:55:08', 20.00, 1),
(8, 25.30, 44.00, 52.00, '2025-05-20 19:57:08', 10.00, 1),
(9, 24.60, 45.00, 55.00, '2025-05-20 20:00:08', 5.50, 1),
(10, 25.00, 46.00, 56.00, '2025-05-20 20:14:00', 5.10, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `telefono`, `direccion`) VALUES
(1, 'Mario Conde', 'marioconde@gmail.com', '76448311', 'Calle Cotahuma'),
(2, 'Santiago Quispe', 'santiago@gmail.com', '66447199', 'Calle Buenos Aires');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `plantas`
--
ALTER TABLE `plantas`
  ADD PRIMARY KEY (`id_planta`),
  ADD KEY `fk_plantas_usuario` (`id_usuario`);

--
-- Indices de la tabla `sensores`
--
ALTER TABLE `sensores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sensores_planta` (`id_planta`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `plantas`
--
ALTER TABLE `plantas`
  MODIFY `id_planta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `sensores`
--
ALTER TABLE `sensores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `plantas`
--
ALTER TABLE `plantas`
  ADD CONSTRAINT `fk_plantas_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `sensores`
--
ALTER TABLE `sensores`
  ADD CONSTRAINT `fk_sensores_planta` FOREIGN KEY (`id_planta`) REFERENCES `plantas` (`id_planta`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
