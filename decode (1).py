#!/usr/bin/env python3
"""
Steganography Decoder for PNG Images
Extracts hidden data using various steganographic techniques
"""

import os
import sys
from PIL import Image
import numpy as np

def extract_lsb_data(image_path):
    """Extract data hidden in Least Significant Bits"""
    try:
        img = Image.open(image_path)
        img_array = np.array(img)
        
        # Extract LSB from each color channel
        binary_data = ""
        
        # Flatten the image array
        flat_array = img_array.flatten()
        
        # Extract LSB from each pixel value
        for pixel_value in flat_array:
            binary_data += str(pixel_value & 1)
        
        # Convert binary to text (8 bits per character)
        extracted_text = ""
        for i in range(0, len(binary_data), 8):
            byte = binary_data[i:i+8]
            if len(byte) == 8:
                char_code = int(byte, 2)
                if 32 <= char_code <= 126:  # Printable ASCII
                    extracted_text += chr(char_code)
                elif char_code == 0:  # Null terminator
                    break
        
        return extracted_text
    except Exception as e:
        return f"LSB extraction error: {str(e)}"

def extract_metadata(image_path):
    """Extract image metadata"""
    try:
        img = Image.open(image_path)
        metadata = {}
        
        # Basic image info
        metadata['format'] = img.format
        metadata['mode'] = img.mode
        metadata['size'] = img.size
        
        # EXIF data if available
        if hasattr(img, '_getexif') and img._getexif():
            metadata['exif'] = img._getexif()
        
        # PNG info
        if hasattr(img, 'info'):
            metadata['png_info'] = img.info
            
        return metadata
    except Exception as e:
        return f"Metadata extraction error: {str(e)}"

def analyze_pixel_patterns(image_path):
    """Analyze pixel patterns for anomalies"""
    try:
        img = Image.open(image_path)
        img_array = np.array(img)
        
        analysis = {}
        
        # Check for unusual patterns in LSBs
        if len(img_array.shape) == 3:  # Color image
            for channel in range(img_array.shape[2]):
                channel_data = img_array[:, :, channel]
                lsb_data = channel_data & 1
                
                # Calculate entropy of LSBs
                unique, counts = np.unique(lsb_data, return_counts=True)
                entropy = -np.sum((counts/counts.sum()) * np.log2(counts/counts.sum()))
                analysis[f'channel_{channel}_lsb_entropy'] = entropy
        
        return analysis
    except Exception as e:
        return f"Pattern analysis error: {str(e)}"

def main():
    image_path = "uploaded_files/UNLOCKED_EVIDENCE_STEGANOGRAPHY.png"
    
    if not os.path.exists(image_path):
        print(f"Error: Image file not found at {image_path}")
        return
    
    print("=" * 60)
    print("STEGANOGRAPHY ANALYSIS REPORT")
    print("=" * 60)
    print(f"File: {image_path}")
    print(f"Size: {os.path.getsize(image_path)} bytes")
    print()
    
    # Extract metadata
    print("1. METADATA ANALYSIS:")
    print("-" * 30)
    metadata = extract_metadata(image_path)
    if isinstance(metadata, dict):
        for key, value in metadata.items():
            print(f"{key}: {value}")
    else:
        print(metadata)
    print()
    
    # LSB extraction
    print("2. LSB DATA EXTRACTION:")
    print("-" * 30)
    lsb_data = extract_lsb_data(image_path)
    if lsb_data and len(lsb_data.strip()) > 0:
        print("Hidden text found:")
        print(f"'{lsb_data[:200]}{'...' if len(lsb_data) > 200 else ''}")
        print(f"Total length: {len(lsb_data)} characters")
    else:
        print("No readable text found in LSB data")
    print()
    
    # Pattern analysis
    print("3. PIXEL PATTERN ANALYSIS:")
    print("-" * 30)
    patterns = analyze_pixel_patterns(image_path)
    if isinstance(patterns, dict):
        for key, value in patterns.items():
            print(f"{key}: {value}")
    else:
        print(patterns)
    print()
    
    print("=" * 60)
    print("ANALYSIS COMPLETE")
    print("=" * 60)

if __name__ == "__main__":
    main()