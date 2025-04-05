import numpy as np

def rotate_matrix(theta, phi):
    R = np.array([
        [np.cos(theta)*np.cos(phi), -np.sin(phi), np.sin(theta)*np.cos(phi)],
        [np.cos(theta)*np.sin(phi),  np.cos(phi), np.sin(theta)*np.sin(phi)],
        [-np.sin(theta),             0,           np.cos(theta)]
    ])
    return R

def J1_matrix(J, K, g, gp):
    Jx = np.array([
        [K+J,       gp,         gp],
        [gp,        J,          g],
        [gp,        g,          J]
    ])
    Jy = np.array([
        [J,         gp,         g],
        [gp,        K+J,       gp],
        [g,         gp,        J]
    ])
    Jz = np.array([
        [J,         g,          gp],
        [g,         J,          gp],
        [gp,        gp,         K+J]
    ])
    return Jx, Jy, Jz

def rotate_J1_matrix(Rx, Ry, Jx, Jy, Jz):
    Jx_rotated = Rx.T @ Jx @ Ry
    Jy_rotated = Rx.T @ Jy @ Ry
    Jz_rotated = Rx.T @ Jz @ Ry
    return Jx_rotated, Jy_rotated, Jz_rotated

def rotate_J3_matrix(Rx, Ry, J3):
    return Rx.T @ Ry * J3