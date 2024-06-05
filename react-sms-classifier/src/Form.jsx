import React, { useState } from 'react';
import axios from 'axios';
import './Form.css';

export default function Form() {
    const [message, setMessage] = useState('');
    const [classification, setClassification] = useState('');

    const onInput = (ev) => {
        setMessage(ev.target.value);
    }

    const handleSubmit = (ev) => {
        ev.preventDefault();
    }

    const handleClassification = async () => {
        const response = await axios.post('http://localhost:5000/classify', { message });
        setClassification(response.data.classification === 0 ? "Ham" : "Spam");
    }

    return (
        <div className="form-container">
            <form onSubmit={handleSubmit} className="classification-form">
                <h2>Message Classifier</h2>
                <textarea 
                    name="msg" 
                    id="msg" 
                    placeholder="Enter your message here" 
                    rows={6} 
                    value={message} 
                    onChange={onInput} 
                />
                <br />
                <button type="submit" onClick={handleClassification}>Predict</button>
                {classification && <h4>Your Message is {classification.toUpperCase()}</h4>}
            </form>
        </div>
    );
}
