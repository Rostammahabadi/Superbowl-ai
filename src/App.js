import React from 'react';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import Auth from './components/Auth';
import { Box } from '@mui/material';

const theme = createTheme({
  palette: {
    primary: {
      main: '#013369', // NFL Blue
    },
    secondary: {
      main: '#D50A0A', // NFL Red
    },
  },
  typography: {
    fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
    button: {
      textTransform: 'none',
    },
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Box
        sx={{
          minHeight: '100vh',
          background: 'linear-gradient(135deg, #013369 0%, #1E4B94 100%)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          position: 'relative',
          '&::before': {
            content: '""',
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            background: 'url(/football-pattern.png) repeat',
            opacity: 0.1,
            pointerEvents: 'none',
          },
        }}
      >
        <Auth />
      </Box>
    </ThemeProvider>
  );
}

export default App;
