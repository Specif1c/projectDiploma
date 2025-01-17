// import { useEffect, useState } from 'react';
// import { ethers } from 'ethers';

// // Components
// import Navigation from './components/Navigation';
// import Search from './components/Search';
// import Home from './components/Home';

// // ABIs
// import RealEstate from './abis/RealEstate.json'
// import Escrow from './abis/Escrow.json'

// // Config
// import config from './config.json';

// function App() {

//   const [provider, setProvider] = useState(null);
//   const [escrow, setEscrow] = useState(null);
//   const [account, setAccount] = useState(null);
//   const [homes, setHomes] = useState([]);
//   const [home, setHome] = useState({});
//   const [loading, setLoading] = useState(false);
//   const [error, setError] = useState('');

//   const [toggle, setToggle] = useState(false);


//   const loadBlockchainData = async () => {
//     const provider = new ethers.providers.Web3Provider(window.ethereum)
//     setProvider(provider)
//     const network = await provider.getNetwork()
//     const signer = provider.getSigner();

//     const realEstate = new ethers.Contract(config[network.chainId].realEstate.address, RealEstate, signer)
//     const totalSupply = await realEstate.totalSupply();
//     const homes = []

//     for (var i = 1; i <= totalSupply; i++) {
//       const uri = await realEstate.mint(`https://ipfs.io/ipfs/QmQVcpsjrA6cr1iJjZAodYwmPekYgbnXGo4DFubJiLc2EB/${i + 1}.json`)
//       //const uri = await realEstate.tokenURI(transaction)
//       const response = await fetch(uri)
//       const metadata = await response.json()
//       homes.push(metadata)
//     }

//     setHomes(homes)
//     console.log(homes)
//     console.log(`Тест: ${1 + 1}`);

//     const escrow = new ethers.Contract(config[network.chainId].escrow.addess, Escrow, provider)
//     setEscrow(escrow)

//     window.ethereum.on('accountsChanged', async () => {
//       const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
//       const account = ethers.utils.getAddress(accounts[0])
//       setAccount(account);
//     })
//   }

//   useEffect(() => {
//     loadBlockchainData()
//   }, [])

//   const togglePop = (home) => {
//     setHome(home)
//     toggle ? setToggle(false) : setToggle(true);
//   }

//   return (
//     <div>
//       <Navigation account={account} setAccount={setAccount} />
//       <Search />

//       <div className='cards__section'>

//         <h3>Homes For You</h3>

//         <hr />

//         <div className='cards'>
//           {homes.map((home, index) => (
//             <div className='card' key={index} onClick={() => togglePop(home)}>
//               <div className='card__image'>
//                 <img src={home.image} alt="Home" />
//               </div>
//               <div className='card__info'>
//                 <h4>{home.attributes[0].value} ETH</h4>
//                 <p>
//                   <strong>{home.attributes[2].value}</strong> bds |
//                   <strong>{home.attributes[3].value}</strong> ba |
//                   <strong>{home.attributes[4].value}</strong> sqft
//                 </p>
//                 <p>{home.address}</p>
//               </div>
//             </div>
//           ))}
//         </div>

//       </div>

//       {toggle && (
//         <Home home={home} provider={provider} account={account} escrow={escrow} togglePop={togglePop} />
//       )}

//     </div>
//   );
// }

// // export default App;

// import { useEffect, useState } from 'react';
// import { ethers } from 'ethers';

// // Components
// import Navigation from './components/Navigation';
// import Search from './components/Search';
// import Home from './components/Home';

// // ABIs
// import RealEstate from './abis/RealEstate.json';
// import Escrow from './abis/Escrow.json';

// // Config
// import config from './config.json';

// function App() {
//     const [provider, setProvider] = useState(null);
//     const [escrow, setEscrow] = useState(null);
//     const [account, setAccount] = useState(null);
//     const [homes, setHomes] = useState([]);
//     const [home, setHome] = useState({});
//     const [loading, setLoading] = useState(false);
//     const [error, setError] = useState('');
//     const [toggle, setToggle] = useState(false);

//     const loadBlockchainData = async () => {
//         try {
//             setLoading(true);
//             const provider = new ethers.providers.Web3Provider(window.ethereum);
//             setProvider(provider);
//             const network = await provider.getNetwork();

//             const realEstateAddress = config[network.chainId]?.realEstate?.address;
//             const escrowAddress = config[network.chainId]?.escrow?.address;
          

//             if (!realEstateAddress || !escrowAddress) {
//                 throw new Error("Contract address not found in config for the current network.");
//             }

//             const realEstate = new ethers.Contract(realEstateAddress, RealEstate, provider);
            
//             let totalSupply = await realEstate.totalSupply();
//             totalSupply = totalSupply.toNumber();
//             console.log("Total Supply:", totalSupply);

            
//             const homes = [];

//             for (var i = 1; i <= totalSupply; i++) {
//               const uri = await realEstate.tokenURI(i)
//               const response = await fetch(uri)
//               const metadata = await response.json()
//               homes.push(metadata)
//             }

//             setHomes(homes);

//             const escrow = new ethers.Contract(escrowAddress, Escrow, provider);
//             setEscrow(escrow);

//             window.ethereum.on('accountsChanged', async () => {
//               const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
//               const account = ethers.utils.getAddress(accounts[0])
//               setAccount(account);
//             })
//         } catch (error) {
//             console.error('Failed to load blockchain data:', error);
//             setError(error.message || 'Failed to load blockchain data');
//         } finally {
//             setLoading(false);
//         }
//     };

//     useEffect(() => {
//         loadBlockchainData();
//     }, []);

//     const togglePop = (home) => {
//         setHome(home);
//         setToggle(!toggle);
//     };
    


//     if (loading) return <div>Loading...</div>;
//     if (error) return <div>Error: {error}</div>;

//     return (
//       <div>
//         <Navigation account={account} setAccount={setAccount} />
//         <Search />
  
//         <div className='cards__section'>
  
//           <h3>Homes For You</h3>
  
//           <hr />
  
//           <div className='cards'>
//             {homes.map((home, index) => (
//               <div className='card' key={index} onClick={() => togglePop(home)}>
//                 <div className='card__image'>
//                   <img src={home.image} alt="Home" />
//                 </div>
//                 <div className='card__info'>
//                   <h4>{home.attributes[0].value} ETH</h4>
//                   <p>
//                     <strong>{home.attributes[2].value}</strong> bds |
//                     <strong>{home.attributes[3].value}</strong> ba |
//                     <strong>{home.attributes[4].value}</strong> sqft
//                   </p>
//                   <p>{home.address}</p>
//                 </div>
//               </div>
//             ))}
//           </div>
  
//         </div>
  
//         {toggle && (
//           <Home home={home} provider={provider} account={account} escrow={escrow} togglePop={togglePop} />
//         )}
  
//       </div>
//     );
//   }
  
//   export default App;

import { useEffect, useState } from 'react';
import { ethers } from 'ethers';

// Components
import Navigation from './components/Navigation';
import Search from './components/Search';
import Home from './components/Home';

// ABIs
import RealEstate from './abis/RealEstate.json'
import Escrow from './abis/Escrow.json'

// Config
import config from './config.json';

function App() {
  const [provider, setProvider] = useState(null)
  const [escrow, setEscrow] = useState(null)

  const [account, setAccount] = useState(null)

  const [homes, setHomes] = useState([])
  const [home, setHome] = useState({})
  const [toggle, setToggle] = useState(false);

  const loadBlockchainData = async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    setProvider(provider)
    const network = await provider.getNetwork()

    const realEstate = new ethers.Contract(config[network.chainId].realEstate.address, RealEstate, provider)
    const totalSupply = await realEstate.totalSupply()
    const homes = []

    for (var i = 1; i <= totalSupply; i++) {
      const uri = await realEstate.tokenURI(i)
      const response = await fetch(uri)
      const metadata = await response.json()
      homes.push(metadata)
    }

    setHomes(homes)

    const escrow = new ethers.Contract(config[network.chainId].escrow.address, Escrow, provider)
    setEscrow(escrow)

    window.ethereum.on('accountsChanged', async () => {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      const account = ethers.utils.getAddress(accounts[0])
      setAccount(account);
    })
  }

  useEffect(() => {
    loadBlockchainData()
  }, [])

  const togglePop = (home) => {
    setHome(home)
    toggle ? setToggle(false) : setToggle(true);
  }

  return (
    <div>
      <Navigation account={account} setAccount={setAccount} />
      <Search />

      <div className='cards__section'>

        <h3>Homes For You</h3>

        <hr />

        <div className='cards'>
          {homes.map((home, index) => (
            <div className='card' key={index} onClick={() => togglePop(home)}>
              <div className='card__image'>
                <img src={home.image} alt="Home" />
              </div>
              <div className='card__info'>
                <h4>{home.attributes[0].value} ETH</h4>
                <p>
                  <strong>{home.attributes[2].value}</strong> bds |
                  <strong>{home.attributes[3].value}</strong> ba |
                  <strong>{home.attributes[4].value}</strong> sqft
                </p>
                <p>{home.address}</p>
              </div>
            </div>
          ))}
        </div>

      </div>

      {toggle && (
        <Home home={home} provider={provider} account={account} escrow={escrow} togglePop={togglePop} />
      )}

    </div>
  );
}

export default App;