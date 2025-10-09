'use client'

import PivoineDocsIcon from './PivoineDocsIcon'

export default function PivoineIconDemo() {
  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #1e293b 0%, #0f172a 100%)',
      padding: '4rem 2rem',
      color: '#fff'
    }}>
      <div style={{
        maxWidth: '1400px',
        margin: '0 auto'
      }}>
        {/* Header */}
        <div style={{ textAlign: 'center', marginBottom: '4rem' }}>
          <h1 style={{
            fontSize: '3rem',
            fontWeight: 'bold',
            background: 'linear-gradient(135deg, #ec4899, #a855f7, #c084fc)',
            backgroundClip: 'text',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            marginBottom: '1rem'
          }}>
            Pivoine Docs Icon
          </h1>
          <p style={{
            fontSize: '1.25rem',
            color: '#94a3b8',
            maxWidth: '600px',
            margin: '0 auto'
          }}>
            A beautiful animated peony blossom icon with interactive states
          </p>
        </div>

        {/* Main Showcase */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
          gap: '3rem',
          marginBottom: '4rem'
        }}>
          {/* Large Interactive */}
          <div style={{
            background: 'rgba(255, 255, 255, 0.05)',
            borderRadius: '1rem',
            padding: '2rem',
            textAlign: 'center',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255, 255, 255, 0.1)'
          }}>
            <h3 style={{ marginBottom: '1.5rem', color: '#f472b6' }}>
              Interactive (Hover & Click)
            </h3>
            <div style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              minHeight: '320px'
            }}>
              <PivoineDocsIcon size="280px" />
            </div>
            <p style={{ color: '#94a3b8', fontSize: '0.875rem', marginTop: '1rem' }}>
              Hover to bloom • Click to close
            </p>
          </div>

          {/* With Label */}
          <div style={{
            background: 'rgba(255, 255, 255, 0.05)',
            borderRadius: '1rem',
            padding: '2rem',
            textAlign: 'center',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255, 255, 255, 0.1)'
          }}>
            <h3 style={{ marginBottom: '1.5rem', color: '#c084fc' }}>
              With Label
            </h3>
            <div style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              minHeight: '320px'
            }}>
              <PivoineDocsIcon size="240px" showLabel />
            </div>
            <p style={{ color: '#94a3b8', fontSize: '0.875rem', marginTop: '1rem' }}>
              Perfect for hero sections
            </p>
          </div>

          {/* Non-Interactive */}
          <div style={{
            background: 'rgba(255, 255, 255, 0.05)',
            borderRadius: '1rem',
            padding: '2rem',
            textAlign: 'center',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255, 255, 255, 0.1)'
          }}>
            <h3 style={{ marginBottom: '1.5rem', color: '#fb7185' }}>
              Static (Non-Interactive)
            </h3>
            <div style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              minHeight: '320px'
            }}>
              <PivoineDocsIcon size="240px" interactive={false} />
            </div>
            <p style={{ color: '#94a3b8', fontSize: '0.875rem', marginTop: '1rem' }}>
              Ideal for favicons & PWA icons
            </p>
          </div>
        </div>

        {/* Size Variations */}
        <div style={{
          background: 'rgba(255, 255, 255, 0.05)',
          borderRadius: '1rem',
          padding: '3rem',
          backdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          marginBottom: '4rem'
        }}>
          <h2 style={{
            fontSize: '2rem',
            fontWeight: 'bold',
            marginBottom: '2rem',
            textAlign: 'center',
            color: '#f0abfc'
          }}>
            Size Variations
          </h2>
          <div style={{
            display: 'flex',
            justifyContent: 'space-around',
            alignItems: 'flex-end',
            flexWrap: 'wrap',
            gap: '2rem',
            padding: '2rem'
          }}>
            <div style={{ textAlign: 'center' }}>
              <PivoineDocsIcon size="64px" />
              <p style={{ color: '#94a3b8', fontSize: '0.75rem', marginTop: '0.5rem' }}>
                64px<br />Favicon
              </p>
            </div>
            <div style={{ textAlign: 'center' }}>
              <PivoineDocsIcon size="96px" />
              <p style={{ color: '#94a3b8', fontSize: '0.75rem', marginTop: '0.5rem' }}>
                96px<br />Small
              </p>
            </div>
            <div style={{ textAlign: 'center' }}>
              <PivoineDocsIcon size="128px" />
              <p style={{ color: '#94a3b8', fontSize: '0.75rem', marginTop: '0.5rem' }}>
                128px<br />Medium
              </p>
            </div>
            <div style={{ textAlign: 'center' }}>
              <PivoineDocsIcon size="192px" />
              <p style={{ color: '#94a3b8', fontSize: '0.75rem', marginTop: '0.5rem' }}>
                192px<br />Large
              </p>
            </div>
            <div style={{ textAlign: 'center' }}>
              <PivoineDocsIcon size="256px" />
              <p style={{ color: '#94a3b8', fontSize: '0.75rem', marginTop: '0.5rem' }}>
                256px<br />X-Large
              </p>
            </div>
          </div>
        </div>

        {/* Feature List */}
        <div style={{
          background: 'rgba(255, 255, 255, 0.05)',
          borderRadius: '1rem',
          padding: '3rem',
          backdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.1)'
        }}>
          <h2 style={{
            fontSize: '2rem',
            fontWeight: 'bold',
            marginBottom: '2rem',
            textAlign: 'center',
            color: '#f0abfc'
          }}>
            Features
          </h2>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
            gap: '2rem'
          }}>
            {[
              {
                icon: '🌸',
                title: 'Realistic Design',
                description: 'Multi-layered peony with natural gradients'
              },
              {
                icon: '✨',
                title: 'Smooth Animations',
                description: 'Gentle breathing in normal state'
              },
              {
                icon: '🎭',
                title: 'Interactive States',
                description: 'Bloom on hover, close on click'
              },
              {
                icon: '💫',
                title: 'Particle Effects',
                description: '12 bloom particles flying around'
              },
              {
                icon: '🎨',
                title: 'Beautiful Colors',
                description: 'Pink to purple gradient palette'
              },
              {
                icon: '♿',
                title: 'Accessible',
                description: 'Reduced motion & touch support'
              },
              {
                icon: '📱',
                title: 'Responsive',
                description: 'Works perfectly on all devices'
              },
              {
                icon: '⚡',
                title: 'High Performance',
                description: 'GPU-accelerated CSS animations'
              }
            ].map((feature, i) => (
              <div key={i} style={{
                padding: '1.5rem',
                background: 'rgba(255, 255, 255, 0.03)',
                borderRadius: '0.75rem',
                border: '1px solid rgba(255, 255, 255, 0.08)'
              }}>
                <div style={{ fontSize: '2rem', marginBottom: '0.75rem' }}>
                  {feature.icon}
                </div>
                <h4 style={{
                  fontSize: '1.125rem',
                  fontWeight: '600',
                  marginBottom: '0.5rem',
                  color: '#fda4af'
                }}>
                  {feature.title}
                </h4>
                <p style={{
                  fontSize: '0.875rem',
                  color: '#94a3b8'
                }}>
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>

        {/* Usage Example */}
        <div style={{
          marginTop: '4rem',
          background: 'rgba(255, 255, 255, 0.05)',
          borderRadius: '1rem',
          padding: '2rem',
          backdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.1)'
        }}>
          <h2 style={{
            fontSize: '1.5rem',
            fontWeight: 'bold',
            marginBottom: '1rem',
            color: '#f0abfc'
          }}>
            Quick Start
          </h2>
          <pre style={{
            background: 'rgba(0, 0, 0, 0.3)',
            padding: '1.5rem',
            borderRadius: '0.5rem',
            overflow: 'auto',
            fontSize: '0.875rem',
            color: '#e2e8f0'
          }}>
{`import PivoineDocsIcon from '@/components/icons/PivoineDocsIcon'

// Basic usage
<PivoineDocsIcon size="256px" />

// With label
<PivoineDocsIcon size="200px" showLabel />

// Static for favicon
<PivoineDocsIcon size="128px" interactive={false} />`}
          </pre>
        </div>

        {/* Footer */}
        <div style={{
          marginTop: '4rem',
          textAlign: 'center',
          color: '#64748b',
          fontSize: '0.875rem'
        }}>
          <p>Made with 🌸 for beautiful documentation experiences</p>
        </div>
      </div>
    </div>
  )
}
