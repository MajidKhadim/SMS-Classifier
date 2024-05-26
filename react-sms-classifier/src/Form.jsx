import React from 'react'
import { useState } from 'react'
import axios from 'axios'

export default function Form() {
    let [message,setMessage] = useState('');
    let [classification,setClassification] = useState('');

    const onInput = (ev)=>{
        setMessage(ev.target.value)
    }
    const handleSubmit = (ev)=>{
        ev.preventDefault();
    }
    const handleClassification = async ()=>{
        const response = await axios.post('http://localhost:5000/classify', { message });
        setClassification(response.data.classification === 0? "Ham":"spam");
    }
  return (
    <form onSubmit={handleSubmit}>
        <h2>Messege Classifier</h2>
        <textarea name="msg" id="msg" placeholder='Enter your messege here' rows={6} cols={100} value={message} onChange={onInput}></textarea>
        <br/>
        <button type='submit' onClick={handleClassification}>Predict</button>
        {classification && <h4>Your Messege is {classification.toUpperCase()}</h4>}
    </form>
  )
}
