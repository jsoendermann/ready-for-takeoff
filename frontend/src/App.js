import React, { useState, useEffect } from 'react'
import styled from '@emotion/styled'

function App() {
    const [noise, setNoise] = useState(0)

    useEffect(() => {
        const ws = new WebSocket('ws://' + window.location.host)
        ws.onmessage = m => {
            const n = Number(m)
            if (Number.isNaN(n)) {
                return
            }
            setNoise(n)
        }
    })

    let bgColor
    if (noise < 60) {
        bgColor = 'limegreen'
    } else if (noise < 80) {
        bgColor = 'lemonchiffon'
    } else {
        bgColor = 'orangered'
    }

    return (
        <Container bgColor={bgColor}>
            <NoiseText>{noise}</NoiseText>
        </Container>
    )
}

const Container = styled.div`
    width: 100vw;
    height: 100vh;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    background-color: ${p => p.bgColor};
`

const NoiseText = styled.p`
    font-size: 100pt;
`

export default App
