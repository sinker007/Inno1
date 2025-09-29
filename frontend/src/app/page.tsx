'use client';

import * as React from 'react';
import { useState, useEffect } from 'react';
import Container from '@mui/material/Container';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import CircularProgress from '@mui/material/CircularProgress';

interface Vendor {
  id: number;
  name: string;
  url: string;
}

async function getVendors(): Promise<Vendor[]> {
  // This will be proxied to the backend by Next.js/deployment environment
  const res = await fetch('/api/vendors');
  if (!res.ok) {
    // This will activate the closest `error.js` Error Boundary
    throw new Error('Failed to fetch data');
  }
  return res.json();
}

export default function HomePage() {
  const [vendors, setVendors] = useState<Vendor[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    getVendors()
      .then((data) => {
        setVendors(data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  return (
    <Container maxWidth="lg">
      <Box sx={{ my: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Third-Party Risk Radar
        </Typography>
        <TableContainer component={Paper}>
          <Table sx={{ minWidth: 650 }} aria-label="vendors table">
            <TableHead>
              <TableRow>
                <TableCell>Vendor Name</TableCell>
                <TableCell>URL</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={2} align="center">
                    <CircularProgress />
                  </TableCell>
                </TableRow>
              ) : error ? (
                 <TableRow>
                  <TableCell colSpan={2} align="center" sx={{ color: 'red' }}>
                    Error: {error}
                  </TableCell>
                </TableRow>
              ) : (
                vendors.map((vendor) => (
                  <TableRow
                    key={vendor.id}
                    sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                  >
                    <TableCell component="th" scope="row">
                      {vendor.name}
                    </TableCell>
                    <TableCell>{vendor.url}</TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </TableContainer>
      </Box>
    </Container>
  );
}