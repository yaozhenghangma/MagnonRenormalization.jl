function k_transform(k, bond)
    @ein Jk[i] := k[i, k] * bond.displace[k]
    return cos.(Jk) .* bond.J
end

function k_mesh_transform(k_mesh, bond)
    @ein Jkk[i, j] := k_mesh[i, j, k] * bond.displace[k]
    return cos.(Jkk) .* bond.J
end

function fourier(sites ,reciprocal_lattice, num_k)
    num_sites = length(sites)
    total_k = num_k[1] * num_k[2] * num_k[3]
    k = k_space(reciprocal_lattice, num_k)
    nk = k .* (-1.0)
    Δk = delta_k_mesh(reciprocal_lattice, num_k)
    Jk = zeros(total_k, num_sites, num_sites)
    Jnk = zeros(total_k, num_sites, num_sites)
    #Jkk = zeros(num_sites, total_k, total_k)
    Jkk = zeros(total_k, total_k, num_sites, num_sites)

    for site in sites
        for bond in site.bonds
            Jk[:, site.index, bond.linked_site] += k_transform(k, bond)
            Jnk[:, site.index, bond.linked_site] += k_transform(nk, bond)
            #if bond.linked_site == site.index
            #    Jkk[site.index, :, :] += k_mesh_transform(Δk, bond)
            #end
            Jkk[:, :, site.index, bond.linked_site] += k_mesh_transform(Δk, bond)
        end
    end

    return Lattice(num_sites, total_k, Jnk, Jk, Jkk)
end
